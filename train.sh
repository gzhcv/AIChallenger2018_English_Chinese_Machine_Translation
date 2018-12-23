#
# train transformer model
#
echo "training the transformer model ..."

# parameters
PATH_ROOT=`pwd`
export PYTHONPATH=$PATH_ROOT/THUMT:$PYTHONPATH
TRAIN_DIR=base
BASE_PARM=batch_size=6250,update_cycle=4,clip_grad_norm=1.0,max_length=128
VALID_EN=valid.en-zh.32k.en
VALID_ZH=valid.en-zh.32k.zh
VALID_SYNC_ZH=valid.en-zh.sync.32k.zh
mkdir -p $TRAIN_DIR

# training on train set 
echo "training on train set ..."

##  stage 1
echo "stage 1: learning rate 2 ..."
python THUMT/thumt/bin/trainer.py --input corpus.en-zh.32k.en.shuf corpus.en-zh.32k.zh.shuf --vocabulary vocab.32k.en.txt vocab.32k.zh.txt --model transformer --validation $VALID_EN --references $VALID_ZH  --output $TRAIN_DIR --parameters=device_list=[0,1,2,3],train_steps=30000,learning_rate=2,$BASE_PARM
rm -rf $TRAIN_DIR/contextual_transformer.json

##  stage 2
echo "stage 2: learning rate 0.5 ..."
python THUMT/thumt/bin/trainer.py --input corpus.en-zh.32k.en.shuf corpus.en-zh.32k.zh.shuf --vocabulary vocab.32k.en.txt vocab.32k.zh.txt --model transformer --validation $VALID_EN --references $VALID_ZH  --output $TRAIN_DIR --parameters=device_list=[0,1,2,3],train_steps=50000,learning_rate=0.5,$BASE_PARM
rm -rf $TRAIN_DIR/contextual_transformer.json

##  stage 3
echo "stage 3: learning rate 0.1 ..."
python THUMT/thumt/bin/trainer.py --input corpus.en-zh.32k.en.shuf corpus.en-zh.32k.zh.shuf --vocabulary vocab.32k.en.txt vocab.32k.zh.txt --model transformer --validation $VALID_EN --references $VALID_ZH  --output $TRAIN_DIR --parameters=device_list=[0,1,2,3],train_steps=70000,learning_rate=0.1,$BASE_PARM
rm -rf $TRAIN_DIR/contextual_transformer.json

# training on validation set
echo "training on validation set: 50 steps, learning rate 0.1 ..."
python THUMT/thumt/bin/trainer.py --input $VALID_EN $VALID_SYNC_ZH --vocabulary vocab.32k.en.txt vocab.32k.zh.txt --model transformer --validation $VALID_EN --references $VALID_ZH  --output $TRAIN_DIR --parameters=device_list=[0,1,2,3],train_steps=70050,learning_rate=0.1
rm -rf $TRAIN_DIR/contextual_transformer.json

#
# train Document-Transformer model
#
echo "training the Document-Transformer model"

# parameters
TRAIN_EN=context.train.en 
TRAIN_ZH=context.train.zh
CONTEXT=context_concat.en 
SRC_VOC=vocab.32k.en.txt 
TGT_VOC=vocab.32k.zh.txt 
OUTPUT=base_context
PARM=train_steps=77050,num_context_layers=1,device_list=[0,1,2,3]
PARM_INIT=train_steps=1,device_list=[0,1,2,3]

mkdir -p mkdir $OUTPUT

# Generate a dummy improved Transformer model
echo "Generate a dummy improved Transformer model ..."
python THUMT/thumt/bin/trainer_ctx.py --input $TRAIN_EN $TRAIN_ZH --context $CONTEXT --vocabulary $SRC_VOC $TGT_VOC --output $OUTPUT --model contextual_transformer  --parameters $PARM_INIT 
rm -rf $OUTPUT/contextual_transformer.json

# Generate the initial model by merging the standard Transformer model into the dummy model
echo "Generate the initial model ..." 
python THUMT/thumt/scripts/combine_add.py --model $OUTPUT/model.ckpt-0 --part $TRAIN_DIR/model.ckpt-70050 --output $OUTPUT
rm -rf $OUTPUT/contextual_transformer.json

# Train the improved Transformer model
echo "Train the improved Transformer model ..."
python THUMT/thumt/bin/trainer_ctx.py --input $TRAIN_EN $TRAIN_ZH --context $CONTEXT --vocabulary $SRC_VOC $TGT_VOC --output $OUTPUT --model contextual_transformer  --parameters $PARM 
