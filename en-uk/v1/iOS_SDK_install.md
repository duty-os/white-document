# Integrate with Podfile

Install with [CocoaPods](https://cocoapods.org/) greatly simplifies the installation process.
First, add the following pods to the Podfile file in the project root:

```ruby
target 'iOSDemo' do
    pod 'White-SDK-iOS'
end
```

Then execute the `pod install` command in the project root directory. After the execution is successful, the SDK is integrated into the project.
If you have not pulled the pod repository for a long time, you may not be able to find our repo. It is recommended to update the pod repository with pod repo update first.

# SDK support situation:

Support for iOS9 and above.
