import SwiftUI
import BuilderIO

struct ContentView: View {
    @ObservedObject var content: BuilderContentWrapper = BuilderContentWrapper();
    
    /**
     var headingText: String;
     var detailText: String;
     var ctaText: String;
     var image: String;
     */
    init() {
        registerComponent(component: BuilderCustomComponent(name: "HeroComponent", 
                                                            inputs: [BuilderInput(name: "headingText", type: "string"),
                                                                     BuilderInput(name: "detailText", type: "string"),
                                                                     BuilderInput(name: "ctaText", type: "string"),
                                                                     BuilderInput(name: "image", type: "string")]),
                          factory: { (options, styles, _) in
            return HeroComponent(headingText: options["headingText"].stringValue, detailText: options["detailText"].stringValue, ctaText: options["ctaText"].stringValue, image: options["image"].stringValue)
        }, apiKey: "e084484c0e0241579f01abba29d9be10");
        fetchContent()
    }
    
    func fetchContent() {
        Content.getContent(model: "page", apiKey: "e084484c0e0241579f01abba29d9be10", url: "/buttons", locale: "", preview: "") { content in
            DispatchQueue.main.async {
                self.content.changeContent(content);
            }
        }
    }
    
    var body: some View {
        VStack {
            ScrollView {
                if $content.content.wrappedValue != nil {
                    RenderContent(content: $content.content.wrappedValue!, apiKey: "e084484c0e0241579f01abba29d9be10") { text, urlString in
                        print("Some one clicked a button!!", text, urlString ?? "empty url");
                    }
                }
//                HeroComponent(headingText: "HEADING TEXT", detailText: "Some details here", ctaText: "Click me", image: "https://cdn.builder.io/api/v1/image/assets/TEMP/5f780b17-6959-4cb2-84a3-f9f8fd20292e?placeholderIfAbsent=true")
            }.frame(idealWidth: .infinity, maxWidth: .infinity)
            
            if (Content.isPreviewing()) {
                Button("Reload") {
                    fetchContent();
                }.onReceive(NotificationCenter.default.publisher(for: deviceDidShakeNotification)) { _ in
                    fetchContent()
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
