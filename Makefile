PKURL='http://your.repos.url/~you/pk/pkeys.tgz'

install:
	install -m 755 -o root -g root vpsgen /usr/local/sbin
	install -d -o root -g root -m 755 /etc/vst
	install -d -o root -g root -m 755 /etc/vst/common
	install -m 644 -o root -g root vstemplate.conf /etc/vst/common/vstemplate.conf
	[ ! -e /etc/vst/vstemplate.conf ] || rm /etc/vst/vstemplate.conf
	install -m 644 -o root -g root shared.sh  /etc/vst/common/shared.sh
	install -m 644 -o root -g root purpose.sh /etc/vst/common/purpose.sh
	install -d -o root -g root -m 755 /etc/vst/templates
	install -m 644 -o root -g root mintagep /etc/vst/templates
	install -d -o root -g root -m 755 /etc/vst/keys
	wget -O - $(PKURL) | (cd /etc/vst/keys ; tar xzf - )

keyinst:
	wget -O - $(PKURL) | (cd /etc/vst/keys ; tar xzf - )
