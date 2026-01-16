//
//  LandmarkMapView.swift
//  Foundation Lab
//
//  Created by xattacker on 2026/1/16.
//

import SwiftUI
import MapKit


struct LandmarkMapView: View {

    let landmarks: [LandmarkInfo]

    @State private var region: MapCameraPosition
    @State private var selectedLandmark: LandmarkInfo?

    init(landmarks: [LandmarkInfo]) {
        self.landmarks = landmarks

        if let first = landmarks.first {
            _region = State(
                initialValue: .region(
                    MKCoordinateRegion(
                        center: first.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    )
                )
            )
        } else {
            _region = State(initialValue: .automatic)
        }
    }

    var body: some View {
        Map(position: $region) {
            ForEach(landmarks) {
                landmark in
                Marker(landmark.title, coordinate: landmark.coordinate)
//                Annotation("", coordinate: landmark.coordinate) {
//                    VStack(spacing: 4) {
//                        Image(systemName: "mappin.circle.fill")
//                            .font(.title)
//                            .foregroundStyle(.red)
//                            .onTapGesture {
//                                selectedLandmark = landmark
//                            }
//                        
//                        if selectedLandmark?.id == landmark.id {
//                            LandmarkCalloutView(landmark: landmark)
//                        }
//                    }
//                }
            }
        }
        .mapControls {
            MapCompass()
            MapScaleView()
        }
    }
}


struct LandmarkCalloutView: View {

    let landmark: LandmarkInfo

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(landmark.title)
                .font(.headline)

            Text(landmark.category)
                .font(.caption)
                .foregroundColor(.secondary)

            Text(landmark.address)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(8)
        .background(.ultraThinMaterial)
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}
