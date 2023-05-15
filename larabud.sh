#!/bin/bash

                               
#  ____  _____ _____ _____ __ __  (TM)
# |    \|  |  |     |  |  |  |  |
# |  |  |  |  |   --|    -|_   _|
# |____/|_____|_____|__|__| |_|  
#                                


## Usage: larabud.sh [options]
##
## Options:
##   -h, --help            Show this help
##   -v, --version         Print version info
##
## All unknown arguments gets passed to the real installer.

#=======================================================================================================================
# Globals
#=======================================================================================================================

    RED="$(tput setaf 1)"
    BLUE="$(tput setaf 4)"
    GRAY="$(tput setaf 7)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"

    RED_BACKGROUND="$(tput setab 1)"
    BLUE_BACKGROUND="$(tput setab 4)"
    GRAY_BACKGROUND="$(tput setab 7)"
    GREEN_BACKGROUND="$(tput setab 2)"
    YELLOW_BACKGROUND="$(tput setab 3)"

    ENDCOLOR="$(tput sgr0)"

    TABULATION="$(printf '\t')"

    WORKING=true
    INSTALLED=false
    INSTALL_MESSAGE="Setting up your new Laravel project..."

#=======================================================================================================================
# Options
#=======================================================================================================================

    NAME=""
    TAILWIND=false
    VUE=false
    FONT_AWESOME=false
    FLOWBITE=false

#=======================================================================================================================
# Files
#=======================================================================================================================

    LAYOUT="
<!doctype html>
<html>
<head>
  <meta charset=\"utf-8\">
  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">

  @vite('resources/css/app.css')
</head>
<body>
  @yield('content')
</body>
@vite('resources/css/app.js')
</html>
    "

    LAYOUT_WITH_FLOWBIITE="
<!doctype html>
<html>
<head>
  <meta charset=\"utf-8\">
  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
  
  @vite('resources/css/app.css')
</head>
<body>
  @yield('content')
</body>

<script src=\"https://cdnjs.cloudflare.com/ajax/libs/flowbite/1.6.5/flowbite.min.js\"></script>
@vite('resources/css/app.js')
</html>
    "

    APP_JS_WITHOUT_FONTAWESOME="
import './bootstrap';
import { createApp } from 'vue';

const app = createApp({});

app.mount('#app');"

    APP_JS_WITH_FONTAWESOME="
import './bootstrap';
import { createApp } from 'vue';
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';
import { library } from 'fortawesome/fontawesome-svg-core';
import { fas } from '@fortawesome/free-solid-svg-icons';
import { fab } from '@fortawesome/free-brands-svg-icons';

const app = createApp({});

library.add(fas, fab);

app.component('font-awesome-icon', FontAwesomeIcon);

app.mount('#app');"

    TAILWIND_CONFIG="
module.exports = {
    content: [
        './resources/**/*.blade.php',
        './resources/**/*.js',
        './resources/**/*.vue',
    ],
    theme: {
        extend: {},
    },
    variants: {},
    plugins: [
        require('@tailwindcss/forms'),
        require('@tailwindcss/typography'),
    ],
}"

    CSS_FILE="
@tailwind base;
@tailwind components;
@tailwind utilities;"

    VITE_CONFIG="
import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import vue from '@vitejs/plugin-vue';

export default defineConfig({
    plugins: [
        laravel({
            input: [
                'resources/sass/app.scss',
                'resources/js/app.js',
            ],
            refresh: true,
        }),
        vue({
            template: {
                transformAssetUrls: {
                    base: null,
                    includeAbsolute: false,
                },
            },
        }),
    ],
    resolve: {
        alias: {
            vue: 'vue/dist/vue.esm-bundler.js',
        },
    },
});"

#=======================================================================================================================
# Functions
#=======================================================================================================================

    function startup()
    {
        clear
        echo "${RED}  ____  _____ _____ _____ __ __  (TM)${ENDCOLOR}"
        echo "${RED} |    \|  |  |     |  |  |  |  |${ENDCOLOR}"
        echo "${RED} |  |  |  |  |   --|    -|_   _|${ENDCOLOR}"
        echo "${RED} |____/|_____|_____|__|__| |_|  ${ENDCOLOR}"
        echo ""
        echo "  ${RED_BACKGROUND}Larabud${ENDCOLOR} - ${GRAY}A Laravel Installer${ENDCOLOR}"
        echo ""

        echo "${BLUE_BACKGROUND} ℹ ${ENDCOLOR} ${BLUE}Checking for dependencies...${ENDCOLOR}"

        if has_composer
        then
            echo "${GREEN_BACKGROUND} ✓ ${ENDCOLOR} ${GREEN}Composer is installed${ENDCOLOR}"
        else
            WORKING=false
            echo "${RED_BACKGROUND} ⛌ ${ENDCOLOR} ${RED}Composer is not installed${ENDCOLOR} ${TABULATION}(https://getcomposer.org/)"
        fi

        if has_npm
        then
            echo "${GREEN_BACKGROUND} ✓ ${ENDCOLOR} ${GREEN}NodeJS is installed${ENDCOLOR}"
        else
            WORKING=false
            echo "${RED_BACKGROUND} ⛌ ${ENDCOLOR} ${RED}NodeJS is not installed${ENDCOLOR} ${TABULATION}(https://nodejs.org/en/)"
        fi

        if ! $WORKING
        then
            echo ""
            echo "${RED_BACKGROUND} ⛌ ${ENDCOLOR} ${RED}Please install the missing dependencies and try again${ENDCOLOR}"
            echo ""
            exit 1
        else
            run
        fi
    }

    function ask_question()
    {
        echo ""
        echo ""
        echo "${GREEN_BACKGROUND} ? ${ENDCOLOR} ${GREEN_BACKGROUND}$1${ENDCOLOR} ${GRAY}$2${ENDCOLOR}"

        printf "${TABULATOR} => "
    }

    function ask_confirmation()
    {
        echo ""
        echo ""
        echo "${BLUE_BACKGROUND} PRESS ENTER TO INSTALL THE INSTANCE OF LARAVEL ${ENDCOLOR}"
    }

    function run()
    {
        ask_question "What is the name of the project?"
        read NAME

        ask_question "Do you want to use tailwind?" "(y/n)"
        read TAILWIND

        ask_question "Do you want to use vuejs?" "(y/n)"
        read VUE


        if [ "$TAILWIND" == "y" ]
        then
            TAILWIND=true
        else
            TAILWIND=false
        fi

        if $TAILWIND
        then
            ask_question "Do you want to use Flowbite?" "(y/n)"
            read FLOWBITE

            if [ "$FLOWBITE" == "y" ]
            then
                FLOWBITE=true
            else
                FLOWBITE=false
            fi
        fi

        if [ "$VUE" == "y" ]
        then
            VUE=true
        else
            VUE=false
        fi

        if $VUE
        then
            ask_question "Do you want to use FontAwesome?" "(y/n)"
            read FONT_AWESOME

            if [ "$FONT_AWESOME" == "y" ]
            then
                FONT_AWESOME=true
            else
                FONT_AWESOME=false
            fi
        fi

        clear
        echo "${GRAY}Project Name${TABULATION}${ENDCOLOR} ${BLUE}${NAME}${ENDCOLOR}"

        if $TAILWIND
        then
            echo "${GRAY}Tailwind${TABULATION}${ENDCOLOR} ${GREEN_BACKGROUND} ✓ ${ENDCOLOR}"
        else
            echo "${GRAY}TailwindCSS${TABULATION}${ENDCOLOR} ${RED_BACKGROUND} ⛌ ${ENDCOLOR}"
        fi

        if $FLOWBITE
        then
            echo "${GRAY}Flowbite${TABULATION}${ENDCOLOR} ${GREEN_BACKGROUND} ✓ ${ENDCOLOR}"
        else
            echo "${GRAY}Flowbite${TABULATION}${ENDCOLOR} ${RED_BACKGROUND} ⛌ ${ENDCOLOR}"
        fi

        if $VUE
        then
            echo "${GRAY}VueJS${TABULATION}${TABULATION}${ENDCOLOR} ${GREEN_BACKGROUND} ✓ ${ENDCOLOR}"
        else
            echo "${GRAY}VueJS${TABULATION}${TABULATION}${ENDCOLOR} ${RED_BACKGROUND} ⛌ ${ENDCOLOR}"
        fi

        if $FONT_AWESOME
        then
            echo "${GRAY}FontAwesome${TABULATION}${ENDCOLOR} ${GREEN_BACKGROUND} ✓ ${ENDCOLOR}"
        else
            echo "${GRAY}FontAwesome${TABULATION}${ENDCOLOR} ${RED_BACKGROUND} ⛌ ${ENDCOLOR}"
        fi

        ask_confirmation
        read

        install
    }

    function has_npm()
    {
        if [ -x "$(command -v npm)" ]; then
            return 0
        else
            return 1
        fi
    }

    function has_composer()
    {
        if [ -x "$(command -v composer)" ]; then
            return 0
        else
            return 1
        fi
    }

    function install()
    {
        clear

        composer create-project --prefer-dist laravel/laravel $NAME
        cd $NAME
        npm install

        if $TAILWIND
        then
            install_tailwind
        fi

        if $VUE
        then
            install_vue
        fi

        configs
        
        INSTALLED=true
        clear
        echo "${GREEN_BACKGROUND} ✓ ${ENDCOLOR} ${GREEN}Project created successfully${ENDCOLOR}"

        echo ""
        echo ""
        echo ""
        echo "${BLUE_BACKGROUND} ℹ ${ENDCOLOR} ${BLUE}Work on the following checklist to start working:${ENDCOLOR}"
        echo "    ${BLUE}1.${ENDCOLOR} ${TABULATION}Change the name and database credentials of the project in the .env file"
        echo "    ${BLUE}2.${ENDCOLOR} ${TABULATION}Run ${GREEN}php artisan migrate${ENDCOLOR} to create the database tables"
        echo "    ${BLUE}3.${ENDCOLOR} ${TABULATION}Run ${GREEN}npm run dev${ENDCOLOR} to compile the assets"
        echo "    ${BLUE}4.${ENDCOLOR} ${TABULATION}Run ${GREEN}php artisan serve${ENDCOLOR} to start the server"
        echo "    ${BLUE}5.${ENDCOLOR} ${TABULATION}Create a new git repository and push the project to it"
        echo ""

        sleep 5

        clear
        echo ""
        echo ""
        echo "${RED}  ____  _____ _____ _____ __ __  (TM)${ENDCOLOR}"
        echo "${RED} |    \|  |  |     |  |  |  |  |${ENDCOLOR}"
        echo "${RED} |  |  |  |  |   --|    -|_   _|${ENDCOLOR}"
        echo "${RED} |____/|_____|_____|__|__| |_|  ${ENDCOLOR}"
        echo ""
        echo "    Thanks for using ${RED_BACKGROUND}Larabud${ENDCOLOR} ♥"
        echo ""
        echo ""

        sleep 3

        echo ""
        echo ""
        echo "${BLUE_BACKGROUND} ℹ ${ENDCOLOR} ${BLUE}Work on the following checklist to start working:${ENDCOLOR}"
        echo "    ${BLUE}1.${ENDCOLOR} ${TABULATION}Change the name and database credentials of the project in the .env file"
        echo "    ${BLUE}2.${ENDCOLOR} ${TABULATION}Run ${GREEN}php artisan migrate${ENDCOLOR} to create the database tables"
        echo "    ${BLUE}3.${ENDCOLOR} ${TABULATION}Run ${GREEN}npm run dev${ENDCOLOR} to compile the assets"
        echo "    ${BLUE}4.${ENDCOLOR} ${TABULATION}Run ${GREEN}php artisan serve${ENDCOLOR} to start the server"
        echo "    ${BLUE}5.${ENDCOLOR} ${TABULATION}Create a new git repository and push the project to it"
        echo ""
        echo ""
        echo ""

        exit 0
    }

    function install_vue()
    {
        npm install vue @vitejs/plugin-vue

        if $FONT_AWESOME
        then
            npm install @fortawesome/fontawesome-svg-core @fortawesome/free-brands-svg-icons @fortawesome/free-solid-svg-icons @fortawesome/vue-fontawesome
        fi

        rm resources/js/app.js

        
    }

    function configs()
    {
        rm resources/js/app.js
        rm tailwind.config.js
        rm resources/css/app.css
        rm vite.config.js

        if $VUE
        then
            echo $VITE_CONFIG >> vite.config.js
        fi

        if $TAILWIND
        then
            echo $TAILWIND_CONFIG >> tailwind.config.js
            echo $CSS_FILE >> resources/css/app.css
        fi

        if $FONT_AWESOME
        then
            echo $APP_JS_WITH_FONTAWESOME >> resources/js/app.js.dcky
        else
            echo $APP_JS_WITHOUT_FONTAWESOME >> resources/js/app.js.dcky
        fi
        
        cp resources/js/app.js.dcky resources/js/app.js

        mkdir resources/views/layouts

        if $FLOWBITE
        then
            echo $LAYOUT_WITH_FLOWBIITE >> resources/views/layouts/app.blade.php
        else
            echo $LAYOUT >> resources/views/layouts/app.blade.php
        fi
    }

    function install_tailwind()
    {
        npm install -D tailwindcss postcss autoprefixer
        npm install @tailwindcss/forms @tailwindcss/typography
        npx tailwindcss init -p
    }

    function start_animation()
    {
        spin[0]="-"
        spin[1]="\\"
        spin[2]="|"
        spin[3]="/"

        while ! $INSTALLED
        do
            for i in "${spin[@]}"
            do
                    clear
                    echo -ne "   $i ${TABULATION}${BLUE}${INSTALL_MESSAGE}${ENDCOLOR}"
                    sleep 0.1
            done  
        done
    }

startup
