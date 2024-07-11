## 一键卸载清除痕迹：

- https://gist.github.com/XGilmar/55f6727a40f78979a6a7f8d5885e3bdd#file-reset_jetbrains_trial-sh



------------------------------------------------------

IDE Eval reset   install :

-  https://cloud.tencent.com/developer/article/1822218

----------------------------goland 卸载  -----------------------------------------------------------

对于装过盗版破解插件的用户

首先删除掉~/目录下的.jetbrains 文件夹

sudo rm ~/.jetbrains -r
然后进入~/.config/JetBrains/GoLandXXX 这里的XXX代表你的版本

我这里是2020.2

cd ~/.config/JetBrains/GoLand2020.2

编辑

sudo vim ./goland64.vmoptions
————————————————

                            版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。

原文链接：https://blog.csdn.net/weixin_42608885/article/details/109381377

