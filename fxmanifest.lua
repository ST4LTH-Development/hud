fx_version 'cerulean'
game 'gta5'
lua54 'yes'

client_scripts {
    'client/*.lua',
}

server_scripts {
    'server/*.lua'
}

shared_scripts {
    'Config.lua'
}

--ui_page 'web/dist/index.html'
ui_page 'http://localhost:3000/' -- Dev

files {
    'web/dist/index.html',
    'web/dist/**/*',
    'web/dist/js/*.js',
    'web/dist/css/*.css',
}
