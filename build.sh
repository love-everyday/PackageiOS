#!/bin/sh
# 该脚本使用方法
# 该脚本根据：https://github.com/stackhou/AutoPacking-iOS 改良而来
# step 1. 在工程根目录新建Shell文件夹，在该文件夹中新建文件build.sh，将该脚本复制到build.sh文件并保存(或者直接复制该文件);
# step 2. 配置该脚本，在build.plist文件中修改scheme和info.plist文件内容;
# step 2. cd到该脚本目录，运行chmod +x build.sh，改变文件权限;
# step 3. 终端运行 sh build.sh;
# step 4. 选择不同选项....
# step 5. Success  🎉 🎉 🎉!

# ************************* 配置 Start ********************************

__BUILD_PLIST_PATH="build.plist"

if test -f ${__BUILD_PLIST_PATH} ; then 
echo "${__LINE_BREAK_LEFT} 找到build.plist文件 ${__LINE_BREAK_RIGHT}"
else
echo "${__LINE_BREAK_LEFT} 未找到build.plist文件 ${__LINE_BREAK_RIGHT}"
exit 1
fi

__SCHEME_NAME=`/usr/libexec/PlistBuddy -c "Print scheme" ${__BUILD_PLIST_PATH}`
__CURRENT_INFO_PLIST_PATH=`/usr/libexec/PlistBuddy -c "Print infoPlistPath" ${__BUILD_PLIST_PATH}`

# ************************* 配置 END ********************************

# 指定打包编译的模式，如：Release, Debug...
echo "\033[36;1m请选择 BUILD_CONFIGURATION (输入序号, 按回车即可) \033[0m"
echo "\033[33;1m1. Debug \033[0m"
echo "\033[33;1m2. Release \033[0m"

read parameter
sleep ${__SLEEP_TIME}
__BUILD_CONFIGURATION_SELECTED="${parameter}"

# 判读用户是否有输入
if [[ "${__BUILD_CONFIGURATION_SELECTED}" == "1" ]]; then
__BUILD_CONFIGURATION="Debug"
elif [[ "${__BUILD_CONFIGURATION_SELECTED}" == "2" ]]; then
__BUILD_CONFIGURATION="Release"
else
echo "${__LINE_BREAK_LEFT} 您输入 BUILD_CONFIGURATION 参数无效!!! ${__LINE_BREAK_RIGHT}"
exit 1
fi

# 工程类型(.xcworkspace项目,赋值true; .xcodeproj项目, 赋值false)
echo "\033[36;1m请选择是否是.xcworkspace项目(输入序号, 按回车即可) \033[0m"
echo "\033[33;1m1. 是 \033[0m"
echo "\033[33;1m2. 否 \033[0m"

read parameter
sleep ${__SLEEP_TIME}
__IS_WORKSPACE_SELECTE="${parameter}"

# 判读用户是否有输入
if [[ "${__IS_WORKSPACE_SELECTE}" == "1" ]]; then
__IS_WORKSPACE=true
elif [[ "${__IS_WORKSPACE_SELECTE}" == "2" ]]; then
__IS_WORKSPACE=false
else
echo "${__LINE_BREAK_LEFT} 您输入是否是.xcworkspace项目 参数无效!!! ${__LINE_BREAK_RIGHT}"
exit 1
fi

# AdHoc, AppStore, Enterprise, Development
echo "\033[36;1m请选择打包方式(输入序号, 按回车即可) \033[0m"
echo "\033[33;1m1. AdHoc \033[0m"
echo "\033[33;1m2. AppStore \033[0m"
echo "\033[33;1m3. Enterprise \033[0m"
echo "\033[33;1m4. Development \033[0m\n"
# 读取用户输入并存到变量里
read parameter
sleep ${__SLEEP_TIME}
__BUILD_METHOD="${parameter}"

# 判读用户是否有输入
if [[ "${__BUILD_METHOD}" == "1" ]]; then
method="ad-hoc"
elif [[ "${__BUILD_METHOD}" == "2" ]]; then
method="app-store"
elif [[ "${__BUILD_METHOD}" == "3" ]]; then
method="enterprise"
elif [[ "${__BUILD_METHOD}" == "4" ]]; then
method="development"
else
echo "${__LINE_BREAK_LEFT} 您输入的打包方式参数无效!!! ${__LINE_BREAK_RIGHT}"
exit 1
fi

# 成功出包后是否自动打开文件夹
echo "\033[36;1m成功出包后是否自动打开文件夹(输入序号, 按回车即可) \033[0m"
echo "\033[33;1m1. 是 \033[0m"
echo "\033[33;1m2. 否 \033[0m"

read parameter
sleep ${__SLEEP_TIME}
__IS_AUTO_OPENT_FILE_SELECTED="${parameter}"

# 判读用户是否有输入
if [[ "${__IS_AUTO_OPENT_FILE_SELECTED}" == "1" ]]; then
__IS_AUTO_OPENT_FILE=true
elif [[ "${__IS_AUTO_OPENT_FILE_SELECTED}" == "2" ]]; then
__IS_AUTO_OPENT_FILE=false
else
echo "${__LINE_BREAK_LEFT} 您输入的成功出包后是否自动打开文件夹 参数错误!!! ${__LINE_BREAK_RIGHT}"
exit 1
fi

echo "${__LINE_BREAK_LEFT} 您选择了 ${__SCHEME_NAME}-${__BUILD_CONFIGURATION} 模式 ${__LINE_BREAK_RIGHT}"

# 配置完毕是否开始打包
echo "\033[36;1m配置完毕是否立即开始打包 (输入序号, 按回车即可) \033[0m"
echo "\033[33;1m1. 是 \033[0m"
echo "\033[33;1m2. 否 \033[0m"

read parameter
sleep ${__SLEEP_TIME}
__IS_START_PACKINF="${parameter}"

# 判读用户是否有输入
if [[ "${__IS_START_PACKINF}" == "1" ]]; then
echo "${__LINE_BREAK_LEFT} 立即开始 ${__LINE_BREAK_RIGHT}"
elif [[ "${__IS_START_PACKINF}" == "2" ]]; then
echo "${__LINE_BREAK_LEFT} 您退出了打包 ${__LINE_BREAK_RIGHT}"
exit 1
else
echo "${__LINE_BREAK_LEFT} 您输入 是否立即开始打包 参数无效!!! ${__LINE_BREAK_RIGHT}"
exit 1
fi

# ===============================自动打包部分=============================

echo "${__LINE_BREAK_LEFT} 使用打包配置文件路径=${ExportOptionsPlistPath} ${__LINE_BREAK_RIGHT}"
# 打包计时
__CONSUME_TIME=0
# 回退到工程目录
cd ../

ExportOptionsPlistPath="./shell/ExportOptions.plist"
`/usr/libexec/PlistBuddy -c "Set method ${method}" ${ExportOptionsPlistPath}`

__PROGECT_PATH=`pwd`
echo "${__LINE_BREAK_LEFT} 进入工程目录=${__PROGECT_PATH} ${__LINE_BREAK_RIGHT}"

# 获取项目名称
__PROJECT_NAME=`find . -name *.xcodeproj | awk -F "[/.]" '{print $(NF-1)}'`

# 当前的plist文件路径
echo "${__LINE_BREAK_LEFT} 当前Info.plist路径= ${__CURRENT_INFO_PLIST_PATH} ${__LINE_BREAK_RIGHT}"
# 获取版本号
__BUNDLE_VERSION=`/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" ${__CURRENT_INFO_PLIST_PATH}`
# 获取编译版本号
__BUNDLE_BUILD_VERSION=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" ${__CURRENT_INFO_PLIST_PATH}`

# 打印版本信息
echo "${__LINE_BREAK_LEFT} 打包版本=${__BUNDLE_VERSION} 编译版本=${__BUNDLE_BUILD_VERSION} ${__LINE_BREAK_RIGHT}"

# 编译生成文件目录
__EXPORT_PATH="./build"

# 指定输出文件目录不存在则创建
if test -d "${__EXPORT_PATH}" ; then
echo "${__LINE_BREAK_LEFT} 保存归档文件和ipa的路径=${__EXPORT_PATH} ${__LINE_BREAK_RIGHT}"
rm -rf ${__EXPORT_PATH}
else
mkdir -pv ${__EXPORT_PATH}
fi

# 归档文件路径
__EXPORT_ARCHIVE_PATH="${__EXPORT_PATH}/${__SCHEME_NAME}.xcarchive"
# ipa 导出路径
__EXPORT_IPA_PATH="${__EXPORT_PATH}"
# 获取时间 如:201706011145
__CURRENT_DATE="$(date +%Y%m%d_%H%M%S)"
# ipa 名字
__IPA_NAME="${__SCHEME_NAME}_V${__BUNDLE_BUILD_VERSION}_${__CURRENT_DATE}"

echo "${__LINE_BREAK_LEFT} 打包APP名字=${__IPA_NAME} ${__LINE_BREAK_RIGHT}"

echo "${__LINE_BREAK_LEFT} 开始构建项目 ${__LINE_BREAK_RIGHT}"

if ${__IS_WORKSPACE} ; then
if [[ ${__BUILD_CONFIGURATION} == "Debug" ]]; then
echo "${__LINE_BREAK_LEFT} 您选择了以 xcworkspace-Debug 模式打包 ${__LINE_BREAK_RIGHT}"
# step 1. Clean
xcodebuild clean  -workspace ${__PROJECT_NAME}.xcworkspace \
-scheme ${__SCHEME_NAME} \
-configuration ${__BUILD_CONFIGURATION}

# step 2. Archive
xcodebuild archive  -workspace ${__PROJECT_NAME}.xcworkspace \
-scheme ${__SCHEME_NAME} \
-configuration ${__BUILD_CONFIGURATION} \
-archivePath ${__EXPORT_ARCHIVE_PATH}

elif [[ ${__BUILD_CONFIGURATION} == "Release" ]]; then
echo "${__LINE_BREAK_LEFT} 您选择了以 xcworkspace-Release 模式打包 ${__LINE_BREAK_RIGHT}"
# step 1. Clean
xcodebuild clean  -workspace ${__PROJECT_NAME}.xcworkspace \
-scheme ${__SCHEME_NAME} \
-configuration ${__BUILD_CONFIGURATION}

# step 2. Archive
xcodebuild archive  -workspace ${__PROJECT_NAME}.xcworkspace \
-scheme ${__SCHEME_NAME} \
-configuration ${__BUILD_CONFIGURATION} \
-archivePath ${__EXPORT_ARCHIVE_PATH}
else
echo "${__LINE_BREAK_LEFT} 您输入的参数不对 😢 😢 😢 ${__LINE_BREAK_RIGHT}"
exit 1
fi
else
if [[ ${__BUILD_CONFIGURATION} == "Debug" ]] ; then
echo "${__LINE_BREAK_LEFT}您选择了以 xcodeproj-Debug 模式打包 ${__LINE_BREAK_RIGHT}"
# step 1. Clean
xcodebuild clean  -project ${__PROJECT_NAME}.xcodeproj \
-scheme ${__SCHEME_NAME} \
-configuration ${__BUILD_CONFIGURATION} \
-alltargets

# step 2. Archive
xcodebuild archive  -project ${__PROJECT_NAME}.xcodeproj \
-scheme ${__SCHEME_NAME} \
-configuration ${__BUILD_CONFIGURATION} \
-archivePath ${__EXPORT_ARCHIVE_PATH}


elif [[ ${__BUILD_CONFIGURATION} == "Release" ]]; then
echo "${__LINE_BREAK_LEFT} 您选择了以 xcodeproj-Release 模式打包 ${__LINE_BREAK_RIGHT}"
# step 1. Clean
xcodebuild clean  -project ${__PROJECT_NAME}.xcodeproj \
-scheme ${__SCHEME_NAME} \
-configuration ${__BUILD_CONFIGURATION} \
-alltargets
# step 2. Archive
xcodebuild archive  -project ${__PROJECT_NAME}.xcodeproj \
-scheme ${__SCHEME_NAME} \
-configuration ${__BUILD_CONFIGURATION} \
-archivePath ${__EXPORT_ARCHIVE_PATH}

else
echo "${__LINE_BREAK_LEFT} 您输入的参数不对 😢 😢 😢 ${__LINE_BREAK_RIGHT}"
exit 1
fi
fi

# 检查是否构建成功
# xcarchive 实际是一个文件夹不是一个文件所以使用 -d 判断
if test -d "${__EXPORT_ARCHIVE_PATH}" ; then
echo "${__LINE_BREAK_LEFT} 项目构建成功 🚀 🚀 🚀 ${__LINE_BREAK_RIGHT}"
else
echo "${__LINE_BREAK_LEFT} 项目构建失败 😢 😢 😢 ${__LINE_BREAK_RIGHT}"
exit 1
fi

echo "${__LINE_BREAK_LEFT} 开始导出ipa文件 ${__LINE_BREAK_RIGHT}"

xcodebuild -exportArchive -archivePath ${__EXPORT_ARCHIVE_PATH} \
-exportPath ${__EXPORT_IPA_PATH} \
-destination generic/platform=ios \
-exportOptionsPlist ${ExportOptionsPlistPath} \
-allowProvisioningUpdates

# 修改ipa文件名称
mv ${__EXPORT_IPA_PATH}/${__SCHEME_NAME}.ipa ${__EXPORT_IPA_PATH}/${__IPA_NAME}.ipa

# 检查文件是否存在
if test -f "${__EXPORT_IPA_PATH}/${__IPA_NAME}.ipa" ; then
echo "${__LINE_BREAK_LEFT} 导出 ${__IPA_NAME}.ipa 包成功 🎉 🎉 🎉 ${__LINE_BREAK_RIGHT}"

# 自动打开文件夹
if ${__IS_AUTO_OPENT_FILE} ; then
open ${__EXPORT_IPA_PATH}
fi

else
echo "${__LINE_BREAK_LEFT} 导出 ${__IPA_NAME}.ipa 包失败 😢 😢 😢 ${__LINE_BREAK_RIGHT}"
exit 1
fi

# 输出打包总用时
echo "${__LINE_BREAK_LEFT} 使用YJShell脚本打包总耗时: ${SECONDS}s ${__LINE_BREAK_RIGHT}"
