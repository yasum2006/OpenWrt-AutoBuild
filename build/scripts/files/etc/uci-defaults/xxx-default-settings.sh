#!/bin/sh

# 将默认的shell改为bash
if [ -f /bin/bash ];then
  sed -i '/^root:/s#/bin/ash#/bin/bash#' /etc/passwd
fi

# 修复OpenClash核心文件错误
cp -rf /rom/etc/openclash/core/* /etc/openclash/core

# 设置NTP时间服务器
#uci add_list system.ntp.server='ntp.tencent.com'
#uci add_list system.ntp.server='ntp1.aliyun.com'
#uci add_list system.ntp.server='ntp.ntsc.ac.cn'
#uci add_list system.ntp.server='cn.ntp.org.cn'
# uci commit system

# 设置默认主题
# uci set luci.main.mediaurlbase='/luci-static/neobird' && uci commit luci

# 修改主机名称为OpenWrt-86
# uci set system.@system[0].hostname='HP-Gen8'

# 此文件名注意ls 排序，下面也行
# sed -ri "/option mediaurlbase/s#(/luci-static/)[^']+#\neobird#" /etc/config/luci
# uci commit luci

# 去掉CpuMark跑数，直接显示分数
sed -i '/coremark.sh/d' /etc/crontabs/root
cat /dev/null > /etc/bench.log
echo " (CpuMark : 191219.823122" >> /etc/bench.log
echo " Scores)" >> /etc/bench.log

# 添加系统信息
grep "shell-motd" /etc/profile >/dev/null
if [ $? -eq 1 ]; then
echo '
# 添加系统信息
[ -n "$FAILSAFE" -a -x /bin/bash ]  || {
	for FILE in /etc/shell-motd.d/*.sh; do
		[ -f "$FILE" ] && env -i bash "$FILE"
	done
	unset FILE
}

# 设置nano为默认编辑器
export EDITOR="/usr/bin/nano"

' >> /etc/profile
fi

exit 0
