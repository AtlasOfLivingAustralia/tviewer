grails.project.class.dir = "target/classes"
grails.project.test.class.dir = "target/test-classes"
grails.project.test.reports.dir = "target/test-reports"
grails.project.target.level = 1.6
grails.project.source.level = 1.6
grails.project.war.file = "target/${appName}-${appVersion}.war"
grails.project.groupId = "au.org.ala"

grails.project.dependency.resolver = "maven"

grails.project.dependency.resolution = {
    // inherit Grails' default dependencies
    inherits("global") {
        // uncomment to disable ehcache
        // excludes 'ehcache'
    }
    log "warn" // log level of Ivy resolver, either 'error', 'warn', 'info', 'debug' or 'verbose'

    repositories {
        mavenLocal()
        mavenRepo("http://nexus.ala.org.au/content/groups/public/")
    }

    dependencies {
    }
    plugins {
        //runtime ":jquery:1.8.0"
        runtime ":resources:1.1.6"
        runtime ":rest:0.7"

        build ":release:3.0.1"
        // plugins for the build system only
        build ":tomcat:7.0.54"

        // plugins for the compile step
        compile ':cache:1.1.1'
        compile ":cache-ehcache:1.0.0"
    }
}
