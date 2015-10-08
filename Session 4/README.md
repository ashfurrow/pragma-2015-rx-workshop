Session 4
=========

Covers:

- Definition of a unit test.
- Install [Quick](https://github.com/Quick/Quick)/[Nimble](https://github.com/Quick/Nimble), [FBSnapshotTestCase](https://github.com/facebook/ios-snapshot-test-case), [Nimble-Snapshots](https://github.com/ashfurrow/Nimble-Snapshots) with CocoaPods.

```rb
target 'Signup DemoTests' do

pod 'Quick'
pod 'Nimble'
pod 'Nimble-Snapshots'

end
```

- How testing with Quick works.
- How to write an effective unit test (one expectation per test).
- Adding tests to Signup and Entities demos from Session 3.
- Use protocol conformance and private functions to limit scope of view models.
- Dependency injection, lazy-loading view models.
- Stubbing view models for snapshot tests ([this plugin](http://github.com/orta/Snapshots) is useful).
- Testing view models individually.

## Next Steps

Make view models added in step 3 conform to new, constrained protocols. Make stub view models that conform so you can test view controllers with snapshots. Test the view models individually.
