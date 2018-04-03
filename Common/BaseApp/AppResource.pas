unit AppResource;

interface

uses
  Windows, Classes, ExtCtrls, Jpeg;

  function GetResString(dll: THandle; ResIndex: Integer): String;
  //procedure ResSetImageFromJpeg(AImage: TImage; dll: THandle; ResName: Integer);
  procedure __InitResourceS1;

var
  STR_00490: String; //'异动原因'
  STR_00501: String; //'品名'
  STR_00513: String; //'规格'
  STR_00570: String; //'摘要'
  STR_00616: String; //'序'
  STR_00786: String; //'库别'
  STR_00835: String; //'科目代码'
  STR_00837: String; //'借方金额'
  STR_00838: String; //'贷方金额'
  STR_01679: String; //'数量'
  STR_02021: String; //'币别'
  STR_02022: String; //'汇率'
  STR_02023: String; //'外币金额'
  STR_02024: String; //'单据 %s，共计 %s 条，总金额 %s'
  STR_02026: String; //'传入之异动单ID[%s]非法！'
  STR_02027: String; //'单身内容为空，无法执行！'
  STR_02028: String; //'严重错误，无法生成异动单号！'
  STR_02029: String; //'料品编号'
  STR_02030: String; //'单位'
  STR_02031: String; //'单价'
  STR_02032: String; //'最小批量'
  STR_02033: String; //'最大批量'
  STR_02034: String; //'品  名'
  STR_02035: String; //'单据 %s，共%s笔，总数量%s 母币总金额%s'
  STR_02036: String; //'单据内容如下：'
  STR_02037: String; //'源文件'
  STR_02038: String; //'源目录'
  STR_02039: String; //'制令单号'
  STR_02040: String; //'上线日期'
  STR_02041: String; //'单据 %s'
  STR_02042: String; //'不能处理的动作[Status from %d change to %d]'
  STR_02043: String; //'此采购收料单已结案，无法撤消！'
  STR_02047: String; //'单据中存在空值的字段[TB_]，无法呈签。'
  STR_02048: String; //'当前单据之状态已补其它用户所修改，请退出再试一次！'
  STR_02049: String; //'单据中存在空值的字段[TBNo_]，无法呈签。'
  STR_02050: String; //'单据中存在空值的字段[AppUser_]，无法呈签。'
  STR_02051: String; //'建档人员不允许为空，无法呈签。'
  STR_02052: String; //'建档人员代码不存在，无法呈签。'
  STR_02053: String; //'单据已经记账，不得重复记账！'
  STR_02054: String; //'单据 %s，共计 %s 条，总金额 %s'
  STR_02055: String; //'单据 %s，共计 %s 条，总金额 %s'
  STR_02056: String; //'单据 %s，共计 %s 条'
  STR_02058: String; //'单据 %s，共计 %s 条，母币总金额 %s'
  STR_02062: String; //'底数'
  STR_02063: String; //'序号'
  STR_02064: String; //'属性名称'
  STR_02065: String; //'属性值'
  STR_02066: String; //'单据 %s，共计 %d 条'
  STR_02067: String; //'通知单：'
  STR_02068: String; //'此单受出退控制，单身对应出货单号不可为空！'
  STR_02069: String; //'找不到指定的厂商代码：%s'
  STR_02071: String; //'找不到指定的公司代码：%s'
  STR_02072: String; //'品管评定'
  STR_02073: String; //'订单 %s，共计 %s 条，总数量'
  STR_02074: String; //'资产编号'
  STR_02075: String; //'资产名称'
  STR_02076: String; //'原有数量'
  STR_02077: String; //'现有数量'
  STR_02078: String; //'原保管部门'
  STR_02079: String; //'原保管人员'
  STR_02080: String; //'原存放位置'
  STR_02081: String; //'现保管部门'
  STR_02082: String; //'现保管人员'
  STR_02083: String; //'现存放位置'
  STR_02084: String; //'产品型号'
  STR_02085: String; //'单据 %s，共计 %s 条，总数量%s, 总金额%s'
  STR_02086: String; //'流量管制已启动：'
  STR_02117: String; //'生成异动单号失败，请再试一次！'
  STR_02118: String; //'职位名称'
  STR_02119: String; //'招聘人数'
  STR_02120: String; //'婚否'
  STR_02121: String; //'性别'
  STR_02122: String; //'学历'
  STR_02123: String; //'待遇'
  STR_02130: String; //'原任职务'
  STR_02131: String; //'调职人员的 ID 不存在,请与系统管理员联络.'
  STR_02132: String; //'员工工号'
  STR_02133: String; //'分数'
  STR_02134: String; //'备注信息'
  STR_02135: String; //'上午'
  STR_02136: String; //'下午'
  STR_02137: String; //'晚上'
  STR_02138: String; //'%s [ %s ]--工作日报表(%s)'
  STR_02139: String; //'工作内容如下：'
  STR_02140: String; //'注册客户'
  STR_02141: String; //'产品名称'
  STR_02142: String; //'认证码'
  STR_02143: String; //'产品序'
  STR_02144: String; //'客户注册单[%s]'
  STR_02145: String; //'单据定义有问题，请与管理员联络！'
  STR_02146: String; //'单据 %s，共%d笔'
  STR_02147: String; //'[审]'
  STR_02148: String; //'单据 %s，%s'
  STR_02149: String; //'申请异动缘由及异动明细：'
  STR_02150: String; //'待签核错误：'
  STR_02151: String; //'传入之邮件ID[%s]非法！'
  STR_02152: String; //'单据 %s，共%d笔'
  STR_02153: String; //'单据主要内容如下：'
  STR_02154: String; //'系统正在忙碌中，请稍等！'
  STR_02155: String; //'安全证书管理器'
  STR_02156: String; //'无法联接到服务器，系统即将终止！'
  STR_02157: String; //'组成'
  STR_02158: String; //'单据 ''%s'''
  STR_02159: String; //'料品描述'
  STR_02200: String; //'0.正式备料'
  STR_02201: String; //'1.超耗备料'
  STR_02202: String; //'制项 %d，料号 %s 没有BOM 资料！'
  STR_02203: String; //'0.不转/1.待转/2.已转'
  STR_02204: String; //'严重错误：BOM 表中[%s->%s]，底数不可为零！'
  STR_02205: String; //'Error: Not found TB=''%s'' in TranT(%d) '
  STR_02206: String; //'没有安排指令单!'
  STR_02207: String; //'没有找到成型指令单记录!'
  STR_02208: String; //'正在批次确认制令用料单，请稍等...'
  STR_02209: String; //'料品 %s 未启动批号管理！'
  STR_02210: String; //'0.待验/1.允收/2.特采/3.全检/4.拒收'
  STR_02211: String; //'复制报表'
  STR_02212: String; //'请输入要复制报表的 PID：'
  STR_02213: String; //'报表复制完成！'
  STR_02214: String; //'开发BOM/标准BOM/制令BOM'
  STR_02215: String; //'单身已有料号存在,生产工序不能更改!'
  STR_02216: String; //'全部转为请购单，共计生成单号 %d 份。'
  STR_02217: String; //'此申购批次已建立申购底稿，您要删除已存在的申购底稿并重新作业吗？'
  STR_02218: String; //'厂商代码为空'
  STR_02219: String; //'采购单别为空'
  STR_02220: String; //'进货库别为空'
  STR_02221: String; //'检测发现：%s！'
  STR_02222: String; //'检测发现错误：%s，仍然决定要将 %s 转请购单吗？'
  STR_02223: String; //'请输入新的料品编号：'
  STR_02224: String; //'已存在的料品编号: %s，不允许重复！'
  STR_02225: String; //'采购单据已有收料记录，无法撤消！'
  STR_02226: String; //'资料已被修改但未保存，要立即保存再继续作业吗？'
  STR_02227: String; //'可用量更新完成！'
  STR_02228: String; //'请先输入制令单号!'
  STR_02229: String; //'输入制项不存在!'
  STR_02230: String; //'输入制令单号不存在!'
  STR_02231: String; //'制令 %s 未发现批次申购单，要自动建立吗？'
  STR_02232: String; //'没有发现未审查的群组！'
  STR_02233: String; //'(%d) - %s# - %s'
  STR_02234: String; //'发现有 %d 个群组未处理，请先进行群组审查！'
  STR_02235: String; //'检测发现制令存在已确认的备料单，要全部撤消吗？'
  STR_02236: String; //'BOM 资料没有发现，请检查！'
  STR_02237: String; //'以标准 BOM 资料备料'
  STR_02238: String; //'以制令 BOM 资料备料'
  STR_02239: String; //'参照历史制令(开窗选择)...'
  STR_02240: String; //'需求数量为零，无法执行拆分动作！'
  STR_02241: String; //'检测结果：未发现任何错误！'
  STR_02242: String; //'制令BOM不存在，要使用标准BOM继续吗？'
  STR_02243: String; //'确定将 %s 由 [%s] 更改为 [%s] 吗？'
  STR_02244: String; //'不允许更改为[%s]！'
  STR_02245: String; //'不允许由 [%s] 更改为[%s]！'
  STR_02246: String; //'制令单号不可以为空，请按制令领料！'
  STR_02247: String; //'备料单号 %s 不存在，请检查！'
  STR_02248: String; //'错误, 退料数量不能大于可退数量!'
  STR_02249: String; //'品管人员'
  STR_02250: String; //'共建立 %d 张请购单，明细共 %d 笔。'
  STR_02251: String; //'打卡日期必须在系统日期范围之内！'
  STR_02252: String; //'考勤卡号不可以为空！'
  STR_02253: String; //'考勤卡号不存在，无法打卡！'
  STR_02254: String; //'设置范围不可以为空！'
  STR_02255: String; //'批次设置完成！'
  STR_02256: String; //'批次设置班次'
  STR_02257: String; //'已保存到第 %d 条记录，请稍等...'
  STR_02258: String; //'错误：必须连结出货单号!'
  STR_02259: String; //'检测发现系统文件 %s 不存在，您确定现在安装吗？'
  STR_02260: String; //'功能代码为 %s 的查询程式已经存在，你需要覆盖此查询吗？'
  STR_02261: String; //'作业已完成！'
  STR_02262: String; //'[OK]仅设置宽度为0的字段，[ALL]设置所有字段，您的决定是？'
  STR_02263: String; //'制令单 %s-%d 已加入批次申购单 %s，不可重复申购！'
  STR_02264: String; //'订单编号不能空!'
  STR_02265: String; //'订购单 %s-%d 不存在或未确认！'
  STR_02266: String; //'出货数量大于订单数量！'
  STR_02267: String; //'出货备品大于订单备品！'
  STR_02268: String; //'订单序错误或料号！'
  STR_02269: String; //'无法继续！'
  STR_02270: String; //'此收料单已验收入库，无法撤消！'
  STR_02271: String; //'制令转单数大于业务订单数,请重新确认!'
  STR_02272: String; //'业务订单总数量 = %g'
  STR_02273: String; //'已转制令单总数量 = %g'
  STR_02274: String; //'本次转制令单数量 = %g'
  STR_02275: String; //'考勤卡号 %s 不存在！'
  STR_02276: String; //'请刷卡！'
  STR_02277: String; //'锁定'
  STR_02278: String; //'上班'
  STR_02279: String; //'下班'
  STR_02280: String; //'所有记录'
  STR_02281: String; //'仅已打卡'
  STR_02282: String; //'仅未打卡'
  STR_02283: String; //'海关料号 %s 找不到，请检查！'
  STR_02284: String; //'海关料号 %s 不属于当前类别，请检查！'
  STR_02285: String; //'您确认要重新编号码？'
  STR_02286: String; //'重新编码完成！'
  STR_02287: String; //'就餐'
  STR_02288: String; //'自动'
  STR_02289: String; //'门禁'
  STR_02290: String; //'关闭'
  STR_02291: String; //'重启'
  STR_02292: String; //'停车'
  STR_02293: String; //'收料日期不在系统日期范围内！'
  STR_02294: String; //'错误：(待验数量 + 合格数量) > (采购数量 + 允超数量)'
  STR_02295: String; //'提示：制令 %s 找不到或该单未确认！'
  STR_02297: String; //'已转部门制令，不可以重新展开BOM！'
  STR_02298: String; //'该备料单已经发料，不能清空！'
  STR_02299: String; //'退货料号在指定采购单中无法找到, 执行终止！[采购单号=%s，料品编号=%s]'
  STR_02356: String; //'指定的用料单已结案[TBNo=%s, PartCode=%s]'
  STR_02383: String; //'指定采购单已结案，执行终止！[采购单号=%s，料品编号=%s]'
  STR_02442: String; //'订单 %s 不存在！'
  STR_03611: String; //'非法的日期格式'
  STR_05336: String; //'帐别维护档[AccYearMonth]中年度参数未输入!'

implementation

uses ApConst, ServerLang;

procedure __InitResourceS1;
begin
  begin
    STR_00490 := ChineseAsString('异动原因');
    STR_00501 := ChineseAsString('品名');
    STR_00513 := ChineseAsString('规格');
    STR_00570 := ChineseAsString('摘要');
    STR_00616 := ChineseAsString('序');
    STR_00786 := ChineseAsString('库别');
    STR_00835 := ChineseAsString('科目代码');
    STR_00837 := ChineseAsString('借方金额');
    STR_00838 := ChineseAsString('贷方金额');
    STR_01679 := ChineseAsString('数量');
    STR_02021 := ChineseAsString('币别');
    STR_02022 := ChineseAsString('汇率'); 
    STR_02023 := ChineseAsString('外币金额'); 
    STR_02024 := ChineseAsString('单据 %s，共计 %s 条，总金额 %s'); 
    STR_02026 := ChineseAsString('传入之异动单ID[%s]非法！'); 
    STR_02027 := ChineseAsString('单身内容为空，无法执行！'); 
    STR_02028 := ChineseAsString('严重错误，无法生成异动单号！'); 
    STR_02029 := ChineseAsString('料品编号'); 
    STR_02030 := ChineseAsString('单位'); 
    STR_02031 := ChineseAsString('单价'); 
    STR_02032 := ChineseAsString('最小批量'); 
    STR_02033 := ChineseAsString('最大批量'); 
    STR_02034 := ChineseAsString('品  名'); 
    STR_02035 := ChineseAsString('单据 %s，共%s笔，总数量%s 母币总金额%s');
    STR_02036 := ChineseAsString('单据内容如下：'); 
    STR_02037 := ChineseAsString('源文件'); 
    STR_02038 := ChineseAsString('源目录'); 
    STR_02039 := ChineseAsString('制令单号'); 
    STR_02040 := ChineseAsString('上线日期'); 
    STR_02041 := ChineseAsString('单据 %s'); 
    STR_02042 := ChineseAsString('不能处理的动作[Status from %d change to %d]'); 
    STR_02043 := ChineseAsString('此采购收料单已结案，无法撤消！'); 
    STR_02047 := ChineseAsString('单据中存在空值的字段[TB_]，无法呈签。'); 
    STR_02048 := ChineseAsString('当前单据之状态已补其它用户所修改，请退出再试一次！'); 
    STR_02049 := ChineseAsString('单据中存在空值的字段[TBNo_]，无法呈签。'); 
    STR_02050 := ChineseAsString('单据中存在空值的字段[AppUser_]，无法呈签。'); 
    STR_02051 := ChineseAsString('建档人员不允许为空，无法呈签。');
    STR_02052 := ChineseAsString('建档人员代码不存在，无法呈签。'); 
    STR_02053 := ChineseAsString('单据已经记账，不得重复记账！'); 
    STR_02054 := ChineseAsString('单据 %s，共计 %s 条，总金额 %s'); 
    STR_02055 := ChineseAsString('单据 %s，共计 %s 条，总金额 %s'); 
    STR_02056 := ChineseAsString('单据 %s，共计 %s 条'); 
    STR_02058 := ChineseAsString('单据 %s，共计 %s 条，母币总金额 %s'); 
    STR_02062 := ChineseAsString('底数'); 
    STR_02063 := ChineseAsString('序号'); 
    STR_02064 := ChineseAsString('属性名称'); 
    STR_02065 := ChineseAsString('属性值'); 
    STR_02066 := ChineseAsString('单据 %s，共计 %d 条'); 
    STR_02067 := ChineseAsString('通知单：'); 
    STR_02068 := ChineseAsString('此单受出退控制，单身对应出货单号不可为空！'); 
    STR_02069 := ChineseAsString('找不到指定的厂商代码：%s'); 
    STR_02071 := ChineseAsString('找不到指定的公司代码：%s'); 
    STR_02072 := ChineseAsString('品管评定'); 
    STR_02073 := ChineseAsString('订单 %s，共计 %s 条，总数量'); 
    STR_02074 := ChineseAsString('资产编号'); 
    STR_02075 := ChineseAsString('资产名称'); 
    STR_02076 := ChineseAsString('原有数量'); 
    STR_02077 := ChineseAsString('现有数量');
    STR_02078 := ChineseAsString('原保管部门'); 
    STR_02079 := ChineseAsString('原保管人员'); 
    STR_02080 := ChineseAsString('原存放位置'); 
    STR_02081 := ChineseAsString('现保管部门'); 
    STR_02082 := ChineseAsString('现保管人员'); 
    STR_02083 := ChineseAsString('现存放位置'); 
    STR_02084 := ChineseAsString('产品型号'); 
    STR_02085 := ChineseAsString('单据 %s，共计 %s 条，总数量%s, 总金额%s'); 
    STR_02086 := ChineseAsString('流量管制已启动：'); 
    STR_02117 := ChineseAsString('生成异动单号失败，请再试一次！');
    STR_02118 := ChineseAsString('职位名称'); 
    STR_02119 := ChineseAsString('招聘人数'); 
    STR_02120 := ChineseAsString('婚否'); 
    STR_02121 := ChineseAsString('性别'); 
    STR_02122 := ChineseAsString('学历'); 
    STR_02123 := ChineseAsString('待遇'); 
    STR_02130 := ChineseAsString('原任职务');
    STR_02131 := ChineseAsString('调职人员的 ID 不存在,请与系统管理员联络.');
    STR_02132 := ChineseAsString('员工工号'); 
    STR_02133 := ChineseAsString('分数'); 
    STR_02134 := ChineseAsString('备注信息'); 
    STR_02135 := ChineseAsString('上午'); 
    STR_02136 := ChineseAsString('下午');
    STR_02137 := ChineseAsString('晚上'); 
    STR_02138 := ChineseAsString('%s [ %s ]--工作日报表(%s)'); 
    STR_02139 := ChineseAsString('工作内容如下：'); 
    STR_02140 := ChineseAsString('注册客户'); 
    STR_02141 := ChineseAsString('产品名称'); 
    STR_02142 := ChineseAsString('认证码'); 
    STR_02143 := ChineseAsString('产品序'); 
    STR_02144 := ChineseAsString('客户注册单[%s]'); 
    STR_02145 := ChineseAsString('单据定义有问题，请与管理员联络！'); 
    STR_02146 := ChineseAsString('单据 %s，共%d笔'); 
    STR_02147 := ChineseAsString('[审]'); 
    STR_02148 := ChineseAsString('单据 %s，%s'); 
    STR_02149 := ChineseAsString('申请异动缘由及异动明细：'); 
    STR_02150 := ChineseAsString('待签核错误：'); 
    STR_02151 := ChineseAsString('传入之邮件ID[%s]非法！'); 
    STR_02152 := ChineseAsString('单据 %s，共%d笔');
    STR_02153 := ChineseAsString('单据主要内容如下：'); 
    STR_02154 := ChineseAsString('系统正在忙碌中，请稍等！'); 
    STR_02155 := ChineseAsString('安全证书管理器'); 
    STR_02156 := ChineseAsString('无法联接到服务器，系统即将终止！'); 
    STR_02157 := ChineseAsString('组成'); 
    STR_02158 := ChineseAsString('单据 %s');
    STR_02159 := ChineseAsString('料品描述'); 
    STR_02200 := ChineseAsString('0.正式备料'); 
    STR_02201 := ChineseAsString('1.超耗备料'); 
    STR_02202 := ChineseAsString('制项 %d，料号 %s 没有BOM 资料！'); 
    STR_02203 := ChineseAsString('0.不转/1.待转/2.已转'); 
    STR_02204 := ChineseAsString('严重错误：BOM 表中[%s->%s]，底数不可为零！'); 
    STR_02205 := ChineseAsString('Error: Not found TB=''%s'' in TranT(%d) '); 
    STR_02206 := ChineseAsString('没有安排指令单!');
    STR_02207 := ChineseAsString('没有找到成型指令单记录!'); 
    STR_02208 := ChineseAsString('正在批次确认制令用料单，请稍等...'); 
    STR_02209 := ChineseAsString('料品 %s 未启动批号管理！'); 
    STR_02210 := ChineseAsString('0.待验/1.允收/2.特采/3.全检/4.拒收'); 
    STR_02211 := ChineseAsString('复制报表'); 
    STR_02212 := ChineseAsString('请输入要复制报表的 PID：'); 
    STR_02213 := ChineseAsString('报表复制完成！'); 
    STR_02214 := ChineseAsString('开发BOM/标准BOM/制令BOM'); 
    STR_02215 := ChineseAsString('单身已有料号存在,生产工序不能更改!'); 
    STR_02216 := ChineseAsString('全部转为请购单，共计生成单号 %d 份。');
    STR_02217 := ChineseAsString('此申购批次已建立申购底稿，您要删除已存在的申购底稿并重新作业吗？'); 
    STR_02218 := ChineseAsString('厂商代码为空'); 
    STR_02219 := ChineseAsString('采购单别为空'); 
    STR_02220 := ChineseAsString('进货库别为空'); 
    STR_02221 := ChineseAsString('检测发现：%s！'); 
    STR_02222 := ChineseAsString('检测发现错误：%s，仍然决定要将 %s 转请购单吗？'); 
    STR_02223 := ChineseAsString('请输入新的料品编号：'); 
    STR_02224 := ChineseAsString('已存在的料品编号: %s，不允许重复！'); 
    STR_02225 := ChineseAsString('采购单据已有收料记录，无法撤消！'); 
    STR_02226 := ChineseAsString('资料已被修改但未保存，要立即保存再继续作业吗？'); 
    STR_02227 := ChineseAsString('可用量更新完成！'); 
    STR_02228 := ChineseAsString('请先输入制令单号!'); 
    STR_02229 := ChineseAsString('输入制项不存在!'); 
    STR_02230 := ChineseAsString('输入制令单号不存在!'); 
    STR_02231 := ChineseAsString('制令 %s 未发现批次申购单，要自动建立吗？'); 
    STR_02232 := ChineseAsString('没有发现未审查的群组！');
    STR_02233 := ChineseAsString('(%d) - %s# - %s'); 
    STR_02234 := ChineseAsString('发现有 %d 个群组未处理，请先进行群组审查！'); 
    STR_02235 := ChineseAsString('检测发现制令存在已确认的备料单，要全部撤消吗？'); 
    STR_02236 := ChineseAsString('BOM 资料没有发现，请检查！'); 
    STR_02237 := ChineseAsString('以标准 BOM 资料备料'); 
    STR_02238 := ChineseAsString('以制令 BOM 资料备料'); 
    STR_02239 := ChineseAsString('参照历史制令(开窗选择)...'); 
    STR_02240 := ChineseAsString('需求数量为零，无法执行拆分动作！'); 
    STR_02241 := ChineseAsString('检测结果：未发现任何错误！'); 
    STR_02242 := ChineseAsString('制令BOM不存在，要使用标准BOM继续吗？');
    STR_02243 := ChineseAsString('确定将 %s 由 [%s] 更改为 [%s] 吗？'); 
    STR_02244 := ChineseAsString('不允许更改为[%s]！'); 
    STR_02245 := ChineseAsString('不允许由 [%s] 更改为[%s]！'); 
    STR_02246 := ChineseAsString('制令单号不可以为空，请按制令领料！'); 
    STR_02247 := ChineseAsString('备料单号 %s 不存在，请检查！'); 
    STR_02248 := ChineseAsString('错误, 退料数量不能大于可退数量!'); 
    STR_02249 := ChineseAsString('品管人员'); 
    STR_02250 := ChineseAsString('共建立 %d 张请购单，明细共 %d 笔。'); 
    STR_02251 := ChineseAsString('打卡日期必须在系统日期范围之内！'); 
    STR_02252 := ChineseAsString('考勤卡号不可以为空！'); 
    STR_02253 := ChineseAsString('考勤卡号不存在，无法打卡！'); 
    STR_02254 := ChineseAsString('设置范围不可以为空！'); 
    STR_02255 := ChineseAsString('批次设置完成！'); 
    STR_02256 := ChineseAsString('批次设置班次'); 
    STR_02257 := ChineseAsString('已保存到第 %d 条记录，请稍等...'); 
    STR_02258 := ChineseAsString('错误：必须连结出货单号!');
    STR_02259 := ChineseAsString('检测发现系统文件 %s 不存在，您确定现在安装吗？'); 
    STR_02260 := ChineseAsString('功能代码为 %s 的查询程式已经存在，你需要覆盖此查询吗？'); 
    STR_02261 := ChineseAsString('作业已完成！'); 
    STR_02262 := ChineseAsString('[OK]仅设置宽度为0的字段，[ALL]设置所有字段，您的决定是？'); 
    STR_02263 := ChineseAsString('制令单 %s-%d 已加入批次申购单 %s，不可重复申购！'); 
    STR_02264 := ChineseAsString('订单编号不能空!'); 
    STR_02265 := ChineseAsString('订购单 %s-%d 不存在或未确认！'); 
    STR_02266 := ChineseAsString('出货数量大于订单数量！'); 
    STR_02267 := ChineseAsString('出货备品大于订单备品！'); 
    STR_02268 := ChineseAsString('订单序错误或料号！');
    STR_02269 := ChineseAsString('无法继续！'); 
    STR_02270 := ChineseAsString('此收料单已验收入库，无法撤消！'); 
    STR_02271 := ChineseAsString('制令转单数大于业务订单数,请重新确认!'); 
    STR_02272 := ChineseAsString('业务订单总数量 = %g'); 
    STR_02273 := ChineseAsString('已转制令单总数量 = %g'); 
    STR_02274 := ChineseAsString('本次转制令单数量 = %g'); 
    STR_02275 := ChineseAsString('考勤卡号 %s 不存在！'); 
    STR_02276 := ChineseAsString('请刷卡！'); 
    STR_02277 := ChineseAsString('锁定'); 
    STR_02278 := ChineseAsString('上班'); 
    STR_02279 := ChineseAsString('下班'); 
    STR_02280 := ChineseAsString('所有记录'); 
    STR_02281 := ChineseAsString('仅已打卡'); 
    STR_02282 := ChineseAsString('仅未打卡'); 
    STR_02283 := ChineseAsString('海关料号 %s 找不到，请检查！'); 
    STR_02284 := ChineseAsString('海关料号 %s 不属于当前类别，请检查！');
    STR_02285 := ChineseAsString('您确认要重新编号码？'); 
    STR_02286 := ChineseAsString('重新编码完成！'); 
    STR_02287 := ChineseAsString('就餐'); 
    STR_02288 := ChineseAsString('自动'); 
    STR_02289 := ChineseAsString('门禁'); 
    STR_02290 := ChineseAsString('关闭'); 
    STR_02291 := ChineseAsString('重启'); 
    STR_02292 := ChineseAsString('停车'); 
    STR_02293 := ChineseAsString('收料日期不在系统日期范围内！'); 
    STR_02294 := ChineseAsString('错误：(待验数量 + 合格数量) > (采购数量 + 允超数量)');
    STR_02295 := ChineseAsString('提示：制令 %s 找不到或该单未确认！'); 
    STR_02297 := ChineseAsString('已转部门制令，不可以重新展开BOM！'); 
    STR_02298 := ChineseAsString('该备料单已经发料，不能清空！'); 
    STR_02299 := ChineseAsString('退货料号在指定采购单中无法找到, 执行终止！[采购单号=%s，料品编号=%s]'); 
    STR_02356 := ChineseAsString('指定的用料单已结案[TBNo=%s, PartCode=%s]');
    STR_02383 := ChineseAsString('指定采购单已结案，执行终止！[采购单号=%s，料品编号=%s]');
    STR_02442 := ChineseAsString('订单 %s 不存在！');  //Resource_Msg
    STR_03611 := ChineseAsString('非法的日期格式');
    STR_05336 := ChineseAsString('帐别维护档中年度参数未输入!');
  end;
end;

function GetResString(dll: THandle; ResIndex: Integer): String;
var
  iSize: Integer;
  Buffer: array [0..1024] of char;
begin
  iSize := LoadString(dll,ResIndex,Buffer,1024);
  Result := Copy(buffer,1,iSize);
end;

{
procedure ResSetImageFromJpeg(AImage: TImage; dll: THandle; ResName: Integer);
var
  jpg: TJpegImage;
  res: TResourceStream;
begin
  jpg := TJpegImage.Create;
  try
    res := TResourceStream.CreateFromID(dll,ResName,'JPG');
    try
      jpg.LoadFromStream(res);
      AImage.Picture.Assign(jpg);
    finally
      res.Free;
    end;
  finally
    jpg.Free;
  end;
end;
}

end.

