### 简介
该方案利用了篇章上下文信息，论文见[Improving the Transformer Translation Model with Document-Level Context](https://arxiv.org/abs/1810.03581)，论文源码[Document-Transformer ](https://github.com/THUNLP-MT/Document-Transformer)。

### 环境
- 系统：ubuntu
- 显卡：nvidia titan x (4卡)
- 语言：python 2.7
- 框架：tensorflow 1.10

### 用法
0. 下载原始数据(如有需要)[AIChallenger_EnZh_MT_Data](https://pan.baidu.com/s/1teDqwd3Tbc7cbacpzPpa7A)  
1. 下载处理过的数据和模型。数据只是做了分词和bpe，未做其它筛选。[网盘密码dr83](https://pan.baidu.com/s/1sfx9z5UypDD93I1Z_0V4mQ)
2. 将网盘文件解压，切换到解压后的文件夹所在目录
3. 训练：``` sh train.sh ```
4. 测试：解码结果位置 ``` testB/output_testB.trans.norm ```
   - 网盘中模型的结果: ``` sh translate_aic_submit.sh ```
   - 本地训练模型的结果： ``` sh translate.sh ```

ps: testB榜提交了两个结果，一个是单模型，另一个是用三个不同训练阶段的模型ensemble解码得到的，不知道是哪个32.1。脚本种设置的训练step数不一定最优，需要调。如有帮助，给个star呗~~~

### 方案详细描述
[AI Challenger_2018英中文本机器翻译_参赛小结](https://zhuanlan.zhihu.com/p/50153808)

