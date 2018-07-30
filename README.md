# 描述
该脚本是改良自[AutoPacking-iOS](https://github.com/stackhou/AutoPacking-iOS)。<br>
基于`Xcode9`开发，支持ad-hoc,app-store,enterprise和development四种模式。<br>
只支持`Automatically manage signing`方式。<br>
# 使用
在项目根目录下创建`shell`目录，然后将`build.sh`，`build.plist`和`ExportOptions.plist`三个文件拷贝该文件夹下。<br>
配置`build.plist`文件中的`scheme`和`infoPlistPath`。<br>
最后运行脚本`build.sh`。