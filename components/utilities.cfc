component  displayname="utilities" hint="Comman functions for the application" output="false" {

	public struct function encodeFormForHTML(n_stcForm){
        r_stcEncodedForm = structNew();
        for (i in n_stcForm) {
            r_stcEncodedForm[i] = encodeForHTML(n_stcForm[i]);
        };
		return r_stcEncodedForm;
	}

}
