#!/bin/sh
# 在构建阶段移除冲突的文件
APP_PATH="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app"
find "${APP_PATH}" -name "OFL.txt" -type f -delete
find "${APP_PATH}" -name "README.txt" -type f -delete
echo "已从应用包中移除冲突的许可证文件和README文件"
exit 0
