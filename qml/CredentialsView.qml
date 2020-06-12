import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

Pane {
    id: pane
    objectName: 'credentialsView'

    Accessible.ignored: true
    padding: 0
    spacing: 0

    property string title: ""
    property string searchQuery: toolBar.searchField.text

    height: app.height - toolBar.height

    function filteredCredentials() {
        if (entries !== null && searchQuery.length > 0) {
            var filteredEntries = entriesComponent.createObject(app)
            for (var i = 0; i < entries.count; i++) {
                var entry = entries.get(i)
                if (!!entry && !!entry.credential && entry.credential.key.match(escapeRegExp(searchQuery, "i"))) {
                    filteredEntries.append(entry)
                }
            }
            return filteredEntries
        }
        return entries
    }

    Component {
        id: entriesComponent
        EntriesModel {
        }
    }

    NoCredentialsSection {
        id: noCredentialsSection
        visible: entries.count === 0 && (!!yubiKey.currentDevice) && yubiKey.currentDeviceValidated
        enabled: visible
        Accessible.ignored: true
    }


    NoResultsSection {
        id: noResultsSection
        visible: entries.count > 0 && (!!yubiKey.currentDevice && yubiKey.currentDeviceValidated)
                 && filteredCredentials().count === 0
        enabled: visible
        Accessible.ignored: true
    }

    CredentialsSection {
        id: credentialsSection
        visible: entries.count > 0
        enabled: visible
    }

}
