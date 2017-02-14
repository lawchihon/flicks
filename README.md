# Flicks

Flicks is a movies app displaying box office and top rental DVDs using [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: 10 (W1) + 6 (W2) hours spent in total

## User Stories

The following **required** functionality is completed:

- [X] User can view a list of movies currently playing in theaters from The Movie Database.
- [X] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [X] User sees a loading state while waiting for the movies API.
- [X] User can pull to refresh the movie list.
- [X] User can view movie details by tapping on a cell.
- [X] User can select from a tab bar for either **Now Playing** or **Top Rated** movies.
- [X] Customize the selection effect of the cell.

The following **optional** features are implemented:

- [X] User sees an error message when there's a networking error.
- [X] Movies are displayed using a CollectionView instead of a TableView.
- [X] User can search for a movie.
- [X] All images fade in as they are loading.
- [X] Customize the UI.
- [X] For the large poster, load the low resolution image first and then switch to the high resolution image when complete.
- [X] Customize the navigation bar.

The following **additional** features are implemented:

- [X] Switch to and back from Collection to TableView
- [X] User can view movie details by tapping on a poster.
- [X] Customize back button
- [X] Customize app icon
- [X] Scroll down to see description in detail

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Right now everytime the user restart the app require to download all the data again, how would we store the data in local so that they don't need to download the same data again and again?
2. Is there anyway the table, poster, and detail view share the same data instead of just passing the link?

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

![Screenshot](walkthrough.gif)

Walkthrough recorded by QuickTime Player.

## Notes

- Most of the develop time spent on waiting for compile.
- Right now the table view and the collection view are not sharing data.


## License

    Copyright 2017 Chi Hon Law

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.4001011013303120.1

