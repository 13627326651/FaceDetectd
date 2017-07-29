var component;
var obj;
var temp;

function createFaceLandmarks() {
    component = Qt.createComponent("FaceLandmarks.qml");
    console.log("create facelandmarks.qml")
    if (component.status == Component.Ready)
        finishCreation();
    else
        component.statusChanged.connect(finishCreation);
}

function finishCreation() {
    if (component.status == Component.Ready) {
        obj = component.createObject(photoPreview);
        obj.faceLandmarks = temp;
        console.log("create object of facelandmarks")
        if (obj == null) {
            // Error Handling
            console.log("Error creating object");
        }
    } else if (component.status == Component.Error) {
        // Error Handling
        console.log("Error loading component:", component.errorString());
    }
}
