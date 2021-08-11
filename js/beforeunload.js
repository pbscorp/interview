function fncEnableSubmit() {
    document.getElementById("submitButton").disabled = false;
    if (document.getElementById("successMsgDiv")) {
        document.getElementById("successMsgDiv").innerText = "";
    }
    g_blnFormHasUnsubmittedData = true;
}
function fncRemoveBeforeUnloadEvent(n_strDiv) {
    g_blnFormHasUnsubmittedData = false;
}
window.onload = function () {
    g_blnFormHasUnsubmittedData = false;
    document.getElementById("submitButton").disabled = true;

    document.getElementById("mainForm").addEventListener('change', fncEnableSubmit);
    document.getElementById("mainForm").addEventListener('submit', fncRemoveBeforeUnloadEvent);
    window.addEventListener("beforeunload", function (e) {
        if (g_blnFormHasUnsubmittedData) {
            e.returnValue = "changes will be lost";
        }
    });
}