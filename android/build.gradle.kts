allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val kotlinVersion = "2.1.20"

rootProject.layout.buildDirectory.set(File("../build"))
subprojects {
    project.layout.buildDirectory.set(File("${rootProject.layout.buildDirectory.get()}/${project.name}"))
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register("clean", Delete::class) {
    delete(rootProject.layout.buildDirectory)
}
