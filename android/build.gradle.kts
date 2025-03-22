allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val kotlinVersion = "2.1.20"

rootProject.buildDir = '../build'
subprojects {
    project.buildDir = "${rootProject.buildDir}/${project.name}"
}
subprojects {
    project.evaluationDependsOn(':app')
}

tasks.register("clean", Delete) {
    delete rootProject.layout.buildDirectory
}
