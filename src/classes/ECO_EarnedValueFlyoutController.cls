public with sharing class ECO_EarnedValueFlyoutController {
    public id sProjectId {
        get;

        set {
            sProjectId = value;

            reload(false);
        }
    }


    public void reload(Boolean force) {
	}    
}