function fncEnableSubmit() {
    document.getElementById("submitButton").disabled = false;
    g_blnFormHasUnsubmittedData = true;
}
function fncRemoveBeforeUnloadEvent() {
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