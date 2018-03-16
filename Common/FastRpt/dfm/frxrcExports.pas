{******************************************}
{                                          }
{             FastReport v4.0              }
{          Language resource file          }
{                                          }
{         Copyright (c) 1998-2008          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxrcExports;

interface

implementation

uses frxRes;

const resXML =
'<?xml version="1.1" encoding="utf-8"?><Resources CodePage="936"><StrRes Name="8000" Text="导出到 Excel"/><StrRes Name="8001" Text="样式"/><StrRes' + 
' Name="8002" Text="图像"/><StrRes Name="8003" Text="合并单元格"/><StrRes Name="8004" Text="快速导出"/><StrRes Name="8005" Text="所见即�' + 
'�得"/><StrRes Name="8006" Text="作为文本"/><StrRes Name="8007" Text="背景"/><StrRes Name="8008" Text="在导出后打开 Excel"/><StrRes Name="' + 
'8009" Text="Excel 文件 (*.xls)|*.xls"/><StrRes Name="8010" Text=".xls"/><StrRes Name="8100" Text="导出到 Excel"/><StrRes Name="8101" Text="样式' + 
'"/><StrRes Name="8102" Text="所见即所得"/><StrRes Name="8103" Text="背景"/><StrRes Name="8104" Text="在导出后打开 Excel"/><StrRes Name="8' + 
'105" Text="XML Excel 文件 (*.xls)|*.xls"/><StrRes Name="8106" Text=".xls"/><StrRes Name="8200" Text="导出到 HTML table"/><StrRes Name="8201" Text' + 
'="在导出后打开"/><StrRes Name="8202" Text="样式"/><StrRes Name="8203" Text="图像"/><StrRes Name="8204" Text="全部在一数据夹"/><StrRes' + 
' Name="8205" Text="固定宽度"/><StrRes Name="8206" Text="页面导览"/><StrRes Name="8207" Text="多页"/><StrRes Name="8208" Text="Mozilla 浏览' + 
'器"/><StrRes Name="8209" Text="背景"/><StrRes Name="8210" Text="HTML 文件 (*.html)|*.html"/><StrRes Name="8211" Text=".html"/><StrRes Name="8300"' + 
' Text="导出到纯文本 (点阵式打印机)"/><StrRes Name="8301" Text="预览 启用/停用"/><StrRes Name="8302" Text=" 导出属性  "/><StrRes ' + 
'Name="8303" Text="分页"/><StrRes Name="8304" Text="OEM 页码"/><StrRes Name="8305" Text="空白行"/><StrRes Name="8306" Text="前置空白"/><StrR' + 
'es Name="8307" Text="页数"/><StrRes Name="8308" Text="输入页数/文件范围，并以逗号分隔(例如:1,3,5-12)"/><StrRes Name="8309" Text=" �' + 
'��率 "/><StrRes Name="8310" Text="X 比率"/><StrRes Name="8311" Text="Y 比率"/><StrRes Name="8312" Text=" 外框 "/><StrRes Name="8313" Text="无"' + 
'/><StrRes Name="8314" Text="简单"/><StrRes Name="8315" Text="图像"/><StrRes Name="8316" Text="仅用OEM代码页"/><StrRes Name="8317" Text="在�' + 
'�出后打开"/><StrRes Name="8318" Text="保存设置"/><StrRes Name="8319" Text=" 预览 "/><StrRes Name="8320" Text="宽度:"/><StrRes Name="8321" ' + 
'Text="高度:"/><StrRes Name="8322" Text="页"/><StrRes Name="8323" Text="放大"/><StrRes Name="8324" Text="缩小"/><StrRes Name="8325" Text="文本' + 
'文件 (点阵式打印机)(*.prn)|*.prn"/><StrRes Name="8326" Text=".prn"/><StrRes Name="8400" Text="打印"/><StrRes Name="8401" Text="打印机"/><' + 
'StrRes Name="8402" Text="名称"/><StrRes Name="8403" Text="设置..."/><StrRes Name="8404" Text="份数"/><StrRes Name="8405" Text="份数"/><StrRes ' + 
'Name="8406" Text=" 打印机初始化设置 "/><StrRes Name="8407" Text="打印机类型"/><StrRes Name="8408" Text=".fpi"/><StrRes Name="8409" Text="' + 
'打印机初始化样版 (*.fpi)|*.fpi"/><StrRes Name="8410" Text=".fpi"/><StrRes Name="8411" Text="打印机初始化样版 (*.fpi)|*.fpi"/><StrRes N' + 
'ame="8500" Text="导出到 RTF"/><StrRes Name="8501" Text="图像"/><StrRes Name="8502" Text="所见即所得"/><StrRes Name="8503" Text="在导出后' + 
'打开"/><StrRes Name="8504" Text="RTF 文件 (*.rtf)|*.rtf"/><StrRes Name="8505" Text=".rtf"/><StrRes Name="8600" Text="导出设置"/><StrRes Name="' + 
'8601" Text=" 图像设置 "/><StrRes Name="8602" Text="JPEG 品质"/><StrRes Name="8603" Text="分辨率 (dpi)"/><StrRes Name="8604" Text="分割文�' + 
'�"/><StrRes Name="8605" Text="剪去页面空白部份"/><StrRes Name="8606" Text="黑白"/><StrRes Name="8700" Text="导出到 PDF"/><StrRes Name="87' + 
'01" Text="压缩"/><StrRes Name="8702" Text="嵌入字体"/><StrRes Name="8703" Text="打印优化"/><StrRes Name="8704" Text="大纲"/><StrRes Name="' + 
'8705" Text="背景"/><StrRes Name="8706" Text="在导出后打开"/><StrRes Name="8707" Text="Adobe PDF 文件 (*.pdf)|*.pdf"/><StrRes Name="8708" Tex' + 
't=".pdf"/><StrRes Name="RTFexport" Text="RTF 文件"/><StrRes Name="BMPexport" Text="BMP 图"/><StrRes Name="JPEGexport" Text="JPEG 图"/><StrRes Name' + 
'="TIFFexport" Text="TIFF 图"/><StrRes Name="TextExport" Text="纯文本 (点阵打印机)"/><StrRes Name="XlsOLEexport" Text="Excel 表格 (OLE)"/><S' + 
'trRes Name="HTMLexport" Text="HTML 文件"/><StrRes Name="XlsXMLexport" Text="Excel 表格 (XML)"/><StrRes Name="PDFexport" Text="PDF 文件"/><StrRes' + 
' Name="ProgressWait" Text="请稍候"/><StrRes Name="ProgressRows" Text="正在建立列"/><StrRes Name="ProgressColumns" Text="正在建立栏"/><Str' + 
'Res Name="ProgressStyles" Text="正在建立样式"/><StrRes Name="ProgressObjects" Text="正在导出对象中"/><StrRes Name="TIFFexportFilter" Text' + 
'="Tiff 图 (*.tif)|*.tif"/><StrRes Name="BMPexportFilter" Text="BMP 图 (*.bmp)|*.bmp"/><StrRes Name="JPEGexportFilter" Text="Jpeg 图 (*.jpg)|*.jpg"/' + 
'><StrRes Name="HTMLNavFirst" Text="首页"/><StrRes Name="HTMLNavPrev" Text="前一页"/><StrRes Name="HTMLNavNext" Text="下一页"/><StrRes Name="HT' + 
'MLNavLast" Text="末页"/><StrRes Name="HTMLNavRefresh" Text="刷新"/><StrRes Name="HTMLNavPrint" Text="打印"/><StrRes Name="HTMLNavTotal" Text="�' + 
'�部页"/><StrRes Name="8800" Text="导出到文本"/><StrRes Name="8801" Text="Text file (*.txt)|*.txt"/><StrRes Name="8802" Text=".txt"/><StrRes Nam' + 
'e="SimpleTextExport" Text="文本文件"/><StrRes Name="8850" Text="导出为CSV"/><StrRes Name="8851" Text="CSV file (*.csv)|*.csv"/><StrRes Name="88' + 
'52" Text=".csv"/><StrRes Name="8853" Text="切分"/><StrRes Name="CSVExport" Text="CSV 文件"/><StrRes Name="8900" Text="通过E-mail发送"/><StrRes' + 
' Name="8901" Text="E-mail"/><StrRes Name="8902" Text="帐户"/><StrRes Name="8903" Text="连接"/><StrRes Name="8904" Text="地址"/><StrRes Name="890' + 
'5" Text="附件"/><StrRes Name="8906" Text="格式"/><StrRes Name="8907" Text="发送地址"/><StrRes Name="8908" Text="发送人"/><StrRes Name="8909' + 
'" Text="主机"/><StrRes Name="8910" Text="登录"/><StrRes Name="8911" Text="邮件"/><StrRes Name="8912" Text="通讯"/><StrRes Name="8913" Text="�' + 
'�本"/><StrRes Name="8914" Text="组织"/><StrRes Name="8915" Text="密码"/><StrRes Name="8916" Text="端口"/><StrRes Name="8917" Text="记录属性' + 
'"/><StrRes Name="8918" Text="请求未填充fields"/><StrRes Name="8919" Text="高级导出设置"/><StrRes Name="8920" Text="签名"/><StrRes Name="8' + 
'921" Text="创建"/><StrRes Name="8922" Text="主题"/><StrRes Name="8923" Text="Best regards"/><StrRes Name="8924" Text="发送邮件到"/><StrRes Na' + 
'me="EmailExport" Text="E-mail"/><StrRes Name="FastReportFile" Text="FastReport file"/><StrRes Name="GifexportFilter" Text="Gif file (*.gif)|*.gif"/><S' + 
'trRes Name="GIFexport" Text="Gif 图像"/><StrRes Name="8950" Text="继续"/><StrRes Name="8951" Text="页头/尾"/><StrRes Name="8952" Text="文本"/' + 
'><StrRes Name="8953" Text="头/尾"/><StrRes Name="8954" Text="空"/><StrRes Name="ODSExportFilter" Text="打开电子表格文档文件 (*.ods)|*.ods' + 
'"/><StrRes Name="ODSExport" Text="打开电子表格文档"/><StrRes Name="ODTExportFilter" Text="打开文本文件文档 (*.odt)|*.odt"/><StrRes Nam' + 
'e="ODTExport" Text="打开文本文档"/><StrRes Name="8960" Text=".ods"/><StrRes Name="8961" Text=".odt"/><StrRes Name="8962" Text="安全"/><StrRes ' + 
'Name="8963" Text="安全设置"/><StrRes Name="8964" Text="所有者密码"/><StrRes Name="8965" Text="用户密码"/><StrRes Name="8966" Text="打印' + 
'文档"/><StrRes Name="8967" Text="修改文档"/><StrRes Name="8968" Text="文本和图形拷贝"/><StrRes Name="8969" Text="添加或修改文本注' + 
'解"/><StrRes Name="8970" Text="PDF 安全"/><StrRes Name="8971" Text="Document information"/><StrRes Name="8972" Text="Information"/><StrRes Name="89' + 
'73" Text="Title"/><StrRes Name="8974" Text="Author"/><StrRes Name="8975" Text="Subject"/><StrRes Name="8976" Text="Keywords"/><StrRes Name="8977" Text' + 
'="Creator"/><StrRes Name="8978" Text="Producer"/><StrRes Name="8979" Text="Authentification"/><StrRes Name="8980" Text="Permissions"/><StrRes Name="89' + 
'81" Text="Viewer"/><StrRes Name="8982" Text="Viewer preferences"/><StrRes Name="8983" Text="Hide toolbar"/><StrRes Name="8984" Text="Hide menubar"/><S' + 
'trRes Name="8985" Text="Hide window user interface"/><StrRes Name="8986" Text="Fit window"/><StrRes Name="8987" Text="Center window"/><StrRes Name="89' + 
'88" Text="Print scaling"/><StrRes Name="8989" Text="Confirmation Reading"/><StrRes Name="9101" Text="Export to DBF"/><StrRes Name="9102" Text="dBase (' + 
'DBF) export"/><StrRes Name="9103" Text=".dbf"/><StrRes Name="9104" Text="Failed to load the file"/><StrRes Name="9105" Text="Failure"/><StrRes Name="9' + 
'106" Text="Field names"/><StrRes Name="9107" Text="Automatically"/><StrRes Name="9108" Text="Manually"/><StrRes Name="9109" Text="Load from file"/><St' + 
'rRes Name="9110" Text="Text files (*.txt)|*.txt|All files|*.*"/><StrRes Name="9111" Text="DBF files (*.dbf)|*.dbf|All files|*.*"/></Resources>' + 
' ';

initialization
  frxResources.AddXML(resXML);

end.
