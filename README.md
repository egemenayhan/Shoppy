# Shoppy

Shoppy is basic shopping app. Nisnass API is used for data source.

### Installation:
Just open and run the project

### Project Structure:
I prefer MVVM-R pattern on my side projects. MVVM-R is classic MVVM pattern with `State` and `Router` extensions. State is our data container which controlled by view model. Router is handling routing on view controller. For further information please check [this blog post](https://medium.com/commencis/using-redux-with-mvvm-on-ios-18212454d676). 

I like to use stackview in dynamic interfaces for easier show/hide handling.

I use Carthage because of better build times.

### Third-party Libs:
1. `Alamofire` for networking
2. `Kingfisher` for image caching

### Missing features:
- Expandable views on detail.
- Image preview on detail.

### Things I would change If I had more time:
- I didn't like current size & color selection handling. I would refactor that part.
- Custom size & color selection view.
- I would use _fields parameter on requests for optimum response.
- Better loading animations on product list.
- I would add unit tests.
- Full image preview on detail.
- Add expandable fields on detail.
- Orange theme.

### Things needed for production:
- Crash tracking tool.
- Analysis tool for track user behaviour.
- Unit tests.
