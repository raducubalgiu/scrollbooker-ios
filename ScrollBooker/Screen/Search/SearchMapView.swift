//
//  SearchMapView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 19.07.2026.
//

import SwiftUI
import MapKit

struct SearchMapView: View {
    let markers: [BusinessMarker]
    @Binding var cameraPosition: MapCameraPosition
    var onRegionChange: (BusinessBoundingBox, Float) -> Void

    @State private var viewportWidth: CGFloat = 0

    private var primaryMarkers: [BusinessMarker] {
        markers.filter { $0.isPrimary }
    }

    private var secondaryMarkers: [BusinessMarker] {
        markers.filter { !$0.isPrimary }
    }

    var body: some View {
        GeometryReader { geo in
            Map(position: $cameraPosition) {
                ForEach(secondaryMarkers) { marker in
                    Annotation(marker.owner.fullName, coordinate: marker.clCoordinates, anchor: .center) {
                        SearchMarkerSecondary(color: marker.businessShortDomain.domainColor)
                            .drawingGroup()
                    }
                }

                ForEach(primaryMarkers) { marker in
                    Annotation(marker.owner.fullName, coordinate: marker.clCoordinates, anchor: .bottom) {
                        SearchMarkerPrimary(
                            imageUrl: marker.mediaFiles.first??.thumbnailUrl,
                            domainColor: marker.businessShortDomain.domainColor
                        )
                        .drawingGroup()
                    }
                }
            }
            .ignoresSafeArea(.all, edges: .top)
            .onAppear { viewportWidth = geo.size.width }
            .onChange(of: geo.size.width) { _, newValue in
                viewportWidth = newValue
            }
            .onMapCameraChange(frequency: .onEnd) { context in
                handleCameraChange(context)
            }
        }
    }

    private func handleCameraChange(_ context: MapCameraUpdateContext) {
        let region = context.region
        let bbox = BusinessBoundingBox(
            minLng: Float(region.center.longitude - region.span.longitudeDelta / 2),
            maxLng: Float(region.center.longitude + region.span.longitudeDelta / 2),
            minLat: Float(region.center.latitude - region.span.latitudeDelta / 2),
            maxLat: Float(region.center.latitude + region.span.latitudeDelta / 2)
        )

        var zoom: Float = 10.0
        if region.span.longitudeDelta > 0, viewportWidth > 0 {
            let rawZoom = log2(Double(viewportWidth) * 360.0 / (region.span.longitudeDelta * 256.0))
            if rawZoom.isFinite {
                zoom = max(1.0, min(20.0, Float(rawZoom)))
            }
        }

        onRegionChange(bbox, zoom)
    }
}
