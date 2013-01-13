modules = {
    application {
        defaultBundle false
        resource url:'js/tviewer.js', disposition: 'head'
        resource url:'js/jquery.ba-bbq.min.js', disposition: 'head'
        resource url:'js/jquery.colorbox-min.js', disposition: 'head'
    }

    html5 {
        resource url:'js/html5.js',
                wrapper: { s -> "<!--[if lt IE 9]>$s<![endif]-->" }
    }

}