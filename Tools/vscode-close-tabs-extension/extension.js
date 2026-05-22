const vscode = require('vscode');

/**
 * @param {vscode.ExtensionContext} context
 */
function activate(context) {
    let disposable = vscode.commands.registerCommand('extension.closeNonTypTabs', async function () {
        const tabsToClose = [];

        // Iterate over all tab groups
        for (const group of vscode.window.tabGroups.all) {
            for (const tab of group.tabs) {
                // Check if the tab should be kept
                let isTypFile = false;

                // Try to get resource URI
                if (tab.input && (tab.input instanceof vscode.TabInputText || tab.input instanceof vscode.TabInputCustom)) {
                    if (tab.input.uri && tab.input.uri.path.endsWith('.typ')) {
                        isTypFile = true;
                    }
                } else if (tab.label && tab.label.endsWith('.typ')) {
                    // Fallback check on label if input is not standard
                    isTypFile = true;
                }

                if (!isTypFile) {
                    tabsToClose.push(tab);
                }
            }
        }

        if (tabsToClose.length > 0) {
            await vscode.window.tabGroups.close(tabsToClose);
            vscode.window.showInformationMessage(`Closed ${tabsToClose.length} non-typst tabs.`);
        } else {
            vscode.window.showInformationMessage('No non-typst tabs to close.');
        }
    });

    context.subscriptions.push(disposable);
}

function deactivate() { }

module.exports = {
    activate,
    deactivate
}
