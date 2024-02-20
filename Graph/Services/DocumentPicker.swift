//
//  DocumentPicker.swift
//  Graph
//
//  Created by Dmitriy Mkrtumyan on 17.02.24.
//

import SwiftUI
import UIKit
import UniformTypeIdentifiers
import Foundation

struct DocumentPickerView: UIViewControllerRepresentable {
    
    var urlCompletion: (URL) -> Void
    
    func makeCoordinator() -> DocumentPickerView.Coordinator {
        return DocumentPickerView.Coordinator(parent: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPickerView>) -> UIDocumentPickerViewController {
        
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.commaSeparatedText])
        documentPicker.allowsMultipleSelection = false
        documentPicker.delegate = context.coordinator
        
        return documentPicker
    }
    
    func updateUIViewController(_ uiViewController: DocumentPickerView.UIViewControllerType,
                                context: UIViewControllerRepresentableContext<DocumentPickerView>) { }
    
    final class Coordinator: NSObject, UIDocumentPickerDelegate {
        
        let parent: DocumentPickerView
        
        init(parent: DocumentPickerView) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            
            guard let url = urls.first,
                    url.startAccessingSecurityScopedResource() else { return }
            
            self.parent.urlCompletion(url)
            
            DispatchQueue.main.async {
                url.stopAccessingSecurityScopedResource()
                print("[DocumentPicker] stopAccessingSecurityScopedResource done")
            }
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            print("Document picker was cancelled")
        }
    }
}

