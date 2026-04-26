# Implementation Plan - Android Release Signing Setup

This plan outlines the steps to configure Android release signing for the Flutter project.

## User Review Required

> [!IMPORTANT]
> **Keystore Password**: I have generated a keystore with the placeholder password `password123`. Please let me know if you would like me to use a different password or if you will update it manually in the `android/key.properties` file later.
> 
> **Distinguished Name (DName)**: The keystore was generated with generic certificate information (`cn=Unknown, ou=Unknown, o=Unknown, c=Unknown`). This is sufficient for signing but you may want to regenerate it with your actual details for production.

## Proposed Changes

### Android Configuration

#### [NEW] [key.properties](file:///d:/Twistark/Mental%20Health/mental_health_ai/android/key.properties)
Create a new properties file to store the keystore information.
- `storePassword=password123`
- `keyPassword=password123`
- `keyAlias=upload`
- `storeFile=../upload-keystore.jks`

#### [MODIFY] [build.gradle.kts](file:///d:/Twistark/Mental%20Health/mental_health_ai/android/app/build.gradle.kts)
Update the Kotlin DSL build file to load `key.properties` and configure the `release` signing config.

```kotlin
// Add at the top of the file
import java.util.Properties
import java.io.FileInputStream

// ...
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    // ...
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
```

## Open Questions

1. Should I proceed with the placeholder password `password123` or would you like to provide a specific one now?
2. Are you okay with the default `dname` values used for the certificate?

## Verification Plan

### Automated Tests
- Verify `android/key.properties` exists and has correct paths.
- Check if `build.gradle.kts` syntax is correct.

### Manual Verification
- The user can run `flutter build apk --release` to verify that signing works.
