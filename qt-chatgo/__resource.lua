resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Taglialegna Serse Dio Re'

version '1.4.2'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
    'config.lua',
	'server/main.lua'
}

client_scripts {
	'config.lua',
	'client/main.lua'
}

dependencies {
	'es_extended'
}


