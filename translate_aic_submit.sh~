# parameters

ROOT=`pwd`/testB
TEST=$ROOT/testB.tok.en
CONTEXT=$ROOT/context_testB.en
OUTPUT=$ROOT/output_testB.trans
OUTPUT_NORM=$ROOT/output_testB.trans.norm
MODEL_DIR=$ROOT/../aic_submit
MODEL_NUM=$MODEL_DIR/model.ckpt-8151
PARM=device_list=[0],decode_alpha=0.6,beam_size=10,num_context_layers=1
export PYTHONPATH=$ROOT/../THUMT:$PYTHONPATH

# decode
echo "decoding ..."
python THUMT/thumt/bin/translator_ctx.py --models contextual_transformer --input $TEST --output $OUTPUT --context $CONTEXT --vocabulary $ROOT/../vocab.32k.en.txt $ROOT/../vocab.32k.zh.txt --checkpoints $MODEL_NUM --parameters=$PARM

sed -r 's/(@@ )|(@@ ?$)//g' < $OUTPUT > $OUTPUT_NORM
rm -rf $OUTPUT
echo "decoding result wirte in file output_testB.trans.norm"


