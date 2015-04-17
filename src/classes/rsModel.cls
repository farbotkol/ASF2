/*************************************************************************
*
* PURPOSE: Base decorator for sObjects
*
* CREATED: 2014 Ethos Solutions - www.ethos.com
* AUTHOR: Jason M. Swenski
***************************************************************************/
public virtual class rsModel implements Comparable{
	
	protected sObject mObj {get; set;}

	public rsModel(sObject obj) {
		mObj = obj;
	}

	public Id getId(){
		return mObj.Id;
	}

	public sObject getObj() {
		return mObj;
	}

	public virtual void save() {
        upsert mObj;
	}

	public virtual void destroy() {
        delete mObj;
	}

	public static void save(List<rsModel> modelList) {
		List<sObject> updateList = new List<sObject>();
		List<sObject> insertList = new List<sObject>();
		for (rsModel tempModel : modelList) {
			if(tempModel.getId() != null) {
				updateList.add(tempModel.getObj());
			} else {
				insertList.add(tempModel.getObj());
			}
		}
		insert insertList;
		update updateList;
	}

	public virtual Integer compareTo(Object compareTo) {
		return -1;
	}
}