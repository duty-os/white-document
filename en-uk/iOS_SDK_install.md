# Cocoapods integration (未完)

If you have Cocoapods installed, skip this step and go straight to the next step.
如果你未接触过 Cocoapods ，我们推荐您阅读 [唐巧的博客-用CocoaPods做iOS程序的依赖管理](https://blog.devtang.com/2014/05/25/use-cocoapod-to-manage-ios-lib-dependency/ "用CocoaPods做iOS程序的依赖管理") ，了解我们为何使用 Cocoapods 。另外文章中提及的淘宝源已经不再维护，需要使用 [Ruby-China RubyGems 镜像](https://gems.ruby-china.org/)替换。

如果觉得上面两个文章比较繁琐，可以直接根据我们提供的简要步骤，进行安装。
* 简要步骤：打开 mac 自带的 终端(terminal)，然后输入依次执行下述命令。

```bash
# 注释：Ruby-China 推荐2.6.x，实际 mac 自带的 ruby 也能用了
gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
gem sources -l
# 注释：上面的命令，应该会输出以下内容，>>> 代表此处为输出
>>> https://gems.ruby-china.com
# 注释：确保只有 gems.ruby-china.com

sudo gem install cocoapods
# 注释：由于我们不需要使用官方库，所以可以不执行 pod setup。
```

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
