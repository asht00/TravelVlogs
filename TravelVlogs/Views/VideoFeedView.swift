/// Copyright (c) 2021 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI
import AVKit




struct VideoFeedView: View {
  @State private var selectedVideo: Video?
  
  @State private var embeddedVideoRate: Float = 0.0
  @State private var embeddedVideoVolume: Float = 0.0

  
  @ViewBuilder
  private func makeFullScreenVideoPlayer(for video: Video) -> some View {
    // 1
    if let url = video.videoURL {
      // 2
      let avPlayer = AVPlayer(url: url)
      // 3
      VideoPlayerView(player: avPlayer)

        // 4
        .edgesIgnoringSafeArea(.all)
        .onAppear {
          // 5
          avPlayer.play()
          embeddedVideoRate = 0.0

        }
    } else {
      ErrorView()
    }
  }

  private let videoClips = VideoClip.urls

  private let videos = Video.fetchLocalVideos() + Video.fetchRemoteVideos()


  var body: some View {
    NavigationView {
      List {
        makeEmbeddedVideoPlayer()
        ForEach(videos) { video in
          Button {
            // Open Video Player
            selectedVideo = video

          } label: {
            VideoRow(video: video)
          }
        }
      }
      .navigationTitle("Travel Vlogs")

      
    }
    .fullScreenCover(item: $selectedVideo) {
      // On Dismiss Closure
      embeddedVideoRate = 1.0

    } content: { item in
      makeFullScreenVideoPlayer(for: item)
    }


  }

  private func makeEmbeddedVideoPlayer() -> some View {
    HStack {
      Spacer()

      LoopingPlayerView(
        videoURLs: videoClips,
        rate: $embeddedVideoRate,
        volume: $embeddedVideoVolume)
        
        .background(Color.black)
        .frame(width: 250, height: 140)
        .cornerRadius(8)
        .shadow(radius: 4)
        .padding(.vertical)
        // 1
        .onAppear {
          embeddedVideoRate = 1
        }

        // 2
        .onTapGesture(count: 2) {
          embeddedVideoRate = embeddedVideoRate == 1.0 ? 2.0 : 1.0
        }

        // 3
        .onTapGesture {
          embeddedVideoVolume = embeddedVideoVolume == 1.0 ? 0.0 : 1.0
        }


      Spacer()
    }
  }
}

struct VideoFeedView_Previews: PreviewProvider {
  static var previews: some View {
    VideoFeedView()
  }
}
