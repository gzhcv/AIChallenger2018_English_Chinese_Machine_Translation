ROOT=`pwd`/testB
SOURCE_XML_FILE=$ROOT/ai_challenger_MTEnglishtoChinese_testB_20180827_en.sgm
IN=$ROOT/output_testB.trans.norm
OUT=$ROOT/testB-output.sgm

./tools/wrap_xml.pl zh $SOURCE_XML_FILE cigit < $IN > $OUT
