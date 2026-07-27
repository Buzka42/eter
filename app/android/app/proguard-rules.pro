# WorkManager builds its Room database reflectively from
# androidx.startup.InitializationProvider, before any of our code runs. R8 sees
# no caller for the generated implementation's no-argument constructor and
# removes it, so the app dies on launch with NoSuchMethodException in every
# minified build. Debug builds do not minify, which is why this only appears in
# release.
-keepclassmembers class * extends androidx.room.RoomDatabase {
    <init>();
}
-keep class * extends androidx.room.RoomDatabase { *; }
-keep class androidx.work.impl.WorkDatabase_Impl { *; }

# WorkManager instantiates Worker subclasses by name.
-keep class * extends androidx.work.Worker
-keep class * extends androidx.work.ListenableWorker {
    public <init>(android.content.Context, androidx.work.WorkerParameters);
}
