#  What is the test here?

This test used to test use cases. Or cases that SurfGen support.

This tests must not to check the correctness of the result.

This tests must check that SurfGen can process specific types of data.

So it should be like a technical requirements live-view - you can see **what types of spec SurfGen** support and **what types SurfGen unsupport**

## How write test

You can write your own test file, but pleae, respect the rules:
- Each file MUST contains headers with cases which are checked by the test. See `ServiceUseCasesTests` for examples.
- Each test class MUST have their own enum with yamls (like `ServiceUseCasesTestsYamls`)
- Each test method should be writen similar to methods in `ServiceUseCasesTests`

If you respect the rules then this tests will be easy read
