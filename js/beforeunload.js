function fncEnableSubmit() {
    document.getElementById("submitButton").disabled=false;
    g_blnFormHasUnsubmittedData = true;
}
function fncRemoveBeforeUnloadEvent (n_strDiv) {
    g_blnFormHasUnsubmittedData = false;
}
window.onload = function () {
    g_blnFormHasUnsubmittedData = false;
    document.getElementById("submitButton").disabled=true;
    
    document.getElementById("bodyID").addEventListener('change', fncEnableSubmit);
    window.addEventListener("beforeunload", function(e) {
        if (g_blnFormHasUnsubmittedData) {
            e.returnValue = " address incomplete";
        }
    });
}