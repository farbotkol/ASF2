public without sharing class INC_RoutingMemberTriggers {
	public INC_RoutingMemberTriggers() {
		
	}

	public void updateGroups(map<id,RoutingMember__c> mapNew, map<id,RoutingMember__c> mapOld){
		Map<String,set<id>> mapUserByRegionToAdd = new map<String,set<id>>();
		Map<String,set<id>> mapUserByRegionToRemove = new map<String,set<id>>();
		set<id> setTempAdd = new set<id>();
		set<id> setTemp = new set<id>();
		set<id> setTempRemove = new set<id>();
		set<id> setTempRem = new set<id>();

		for(RoutingMember__c NewMember: mapNew.Values()){
			setTemp = new set<id>();
			if(mapOld != null){
				if(NewMember.Approver1__c != mapOld.get(NewMember.ID).Approver1__c){
					setTemp.add(NewMember.Approver1__c);
					if(mapOld.get(NewMember.id).Approver1__c != null){
						setTempRem.add(mapOld.get(NewMember.ID).Approver1__c);
					}
				} 
				if(NewMember.Approver2__c != mapOld.get(NewMember.ID).Approver2__c){
					setTemp.add(NewMember.Approver2__c);
					if(mapOld.get(NewMember.id).Approver2__c != null){
						setTempRem.add(mapOld.get(NewMember.ID).Approver2__c);
					}
				}
				if(NewMember.Approver3__c != mapOld.get(NewMember.ID).Approver3__c){
					setTemp.add(NewMember.Approver3__c);
					if(mapOld.get(NewMember.id).Approver3__c != null){
						setTempRem.add(mapOld.get(NewMember.ID).Approver3__c);
					}
				}
			
				if(NewMember.FinanceManager__c != mapOld.get(NewMember.ID).FinanceManager__c){
					setTemp.add(NewMember.FinanceManager__c);
					if(mapOld.get(NewMember.id).FinanceManager__c != null){
						setTempRem.add(mapOld.get(NewMember.ID).FinanceManager__c);
					}
				}
			
				if(NewMember.DTW_Approver_Group__c != mapOld.get(NewMember.ID).DTW_Approver_Group__c){
					//if group has changed, need to put all approvers from new into the add
					if(NewMember.Approver1__c != null){
						setTemp.add(NewMember.Approver1__c);
					}
					if(NewMember.Approver2__c != null){
						setTemp.add(NewMember.Approver2__c);
					}
					if(NewMember.Approver3__c != null){
						setTemp.add(NewMember.Approver3__c);
					}
					//if group has changed, need to put all old approvers in remove map
					if(mapOld.get(NewMember.id).Approver1__c != null){
						setTempRem.add(mapOld.get(NewMember.ID).Approver1__c);
					}
					if(mapOld.get(NewMember.id).Approver2__c != null){
						setTempRem.add(mapOld.get(NewMember.ID).Approver2__c);
					}
					if(mapOld.get(NewMember.id).Approver3__c != null){
						setTempRem.add(mapOld.get(NewMember.ID).Approver3__c);
					}
				}
			}else{
				//need to add code for new records
				if(NewMember.Approver1__c != null){
					setTemp.add(NewMember.Approver1__c);
				}
				if(NewMember.Approver2__c != null){
					setTemp.add(NewMember.Approver2__c);
				}
				if(NewMember.Approver3__c != null){
					setTemp.add(NewMember.Approver3__c);
				}
				if(NewMember.FinanceManager__c != null){
					setTemp.add(NewMember.FinanceManager__c);
				}
			}
	
			if(setTemp != null && setTemp.size() > 0){
				if(mapUserByRegionToAdd.containsKey(NewMember.DTW_Approver_Group__c)){
					setTempAdd = mapUserByRegionToAdd.get(NewMember.DTW_Approver_Group__c);
				}
				else{
					setTempAdd = new set<id>();
				}

				setTempAdd.addAll(setTemp);
				mapUserByRegionToAdd.put(NewMember.DTW_Approver_Group__c,setTempAdd);
				if(setTempRem != null && setTempRem.size() > 0){
					if(mapUserByRegionToRemove.containsKey(mapOld.get(NewMember.ID).DTW_Approver_Group__c)){
						setTempRemove = mapUserByRegionToRemove.get(mapOld.get(NewMember.ID).DTW_Approver_Group__c);
					}else{
						setTempRemove = new set<id>();
					}
					setTempRemove.addAll(setTempRem);
					mapUserByRegionToRemove.put(mapOld.get(NewMember.id).DTW_Approver_Group__c,setTempRemove);
				}
			}
		}
		mapUserByRegionToRemove = findApproversToRemove(mapUserByRegionToRemove);
		buildDataForFutureCall(mapUserByRegionToAdd,mapUserByRegionToRemove);
	}
	private map<String,set<id>> findApproversToRemove(map<String,set<id>> mapUserByRegionToRemove){
		map<String,set<id>> mapReturn = new map<String,set<id>>();
		map<String,set<id>> mapApproversByRegion = new map<String,set<id>>();
		set<id> setTemp = new set<id>();
		for(RoutingMember__c Member: [Select id
											   , DTW_Approver_Group__c
											   , Approver1__c
											   , Approver2__c
											   , Approver3__c
									  From RoutingMember__c
									  where DTW_Approver_Group__c =: mapUserByRegionToRemove.keySet()]){
			if(mapApproversByRegion != null && mapApproversByRegion.containsKey(Member.DTW_Approver_Group__c)){
				setTemp = mapApproversByRegion.get(Member.DTW_Approver_Group__c);
			}else{
				setTemp = new set<id>();
			}
			if(Member.Approver1__c != null){
				setTemp.Add(Member.Approver1__c);
			}
			if(Member.Approver2__c != null){
				setTemp.Add(Member.Approver2__c);
			}
			if(Member.Approver3__c != null){
				setTemp.Add(Member.Approver3__c);
			}
			mapApproversByRegion.put(Member.DTW_Approver_Group__c,setTemp);
		}

		//now loop thru the users to remove to see if they still exist on another member object
		//for the same region
		for(String Region: mapUserByRegionToRemove.KeySet()){
			for(id Approver: mapUserByRegionToRemove.get(Region)){
				if(mapApproversByRegion == null ||
				   mapApproversByRegion.size() == 0 || 
				  !mapApproversByRegion.get(Region).Contains(Approver)){
					if(mapReturn != null && mapReturn.containsKey(Region)){
						setTemp = mapReturn.get(Region);
					}else{
						setTemp = new set<id>();
					}
					setTemp.add(Approver);
					mapReturn.put(Region,setTemp);
				}
			}
		}

		return mapReturn;
	}

	private void buildDataForFutureCall(map<String,set<id>>mapAdd,map<String,set<id>>MapRemove){
		//need to convert the maps to a primitive data type
		List<String> lAdd = new list<String>();
		list<String> lRemove = new list<String>();

		for(String sGroupID: mapAdd.keyset()){
			Set<id> listUsers = mapAdd.get(sGroupID);
			for(ID UserID: listUsers){
				lAdd.add(sGroupID + ',' + UserID);
			}
		}

		for(String sGroupID: mapRemove.keyset()){
			Set<id> listUsers = mapRemove.get(sGroupID);
			for(ID UserID: listUsers){
				lRemove.add(sGroupID + ',' + UserID);
			}
		}

		updateGroups(lAdd,lRemove);
	}
	@future 
	private static void updateGroups(list<String>ladd,list<String>lRemove){
		map<String,Set<id>> mapAdd = new map<String,Set<id>>();
		map<String,Set<id>> mapRemove = new map<String,Set<id>>();
		List<String>lTemp = new List<String>();
		Set<id> sTempID = new Set<id>();
		//now rebuild back into the maps for the rest of the process
		for(String sFull: lAdd){
			lTemp = sFull.Split(',');
			String sGroup = lTemp[0];
			ID userID = ID.ValueOf(lTemp[1]);
			if(mapAdd.containsKey(sGroup)){
				sTempID = mapAdd.get(sGroup);
			}else{
				sTempID = new set<id>();
			}
			sTempID.add(userID);
			mapAdd.put(sGroup,sTempID);
		}

		for(String sFull: lRemove){
			lTemp = sFull.Split(',');
			String sGroup = lTemp[0];
			ID userID = ID.ValueOf(lTemp[1]);
			if(mapRemove.containsKey(sGroup)){
				sTempID = mapRemove.get(sGroup);
			}else{
				sTempID = new set<id>();
			}
			sTempID.add(userID);
			mapRemove.put(sGroup,sTempID);
		}
		INC_RoutingMemberTriggers.updateGroups(mapAdd,mapRemove);
	}

	public static void updateGroups(map<String,set<id>>MapAdd,map<String,set<id>>MapRemove){
		set<String> setAllGroups = new set<String>();
		list<GroupMember> listAdd = new list<GroupMember>();
		list<GroupMember> listDel = new list<GroupMember>();

		setAllGroups.addAll(mapAdd.keySet());
		setAllGroups.addAll(mapRemove.keySet());

		map<String,Group> mapGroups = new map<String,Group>();
		for(Group oGroup: 	[Select ID
									, Name
						   	From Group
							where Name =: setAllGroups]){
			mapGroups.put(oGroup.Name,oGroup);
		}

		for(String sGroup: mapAdd.KeySet()){
			for(ID userToAdd : mapAdd.Get(sGroup)){
				ID groupID = mapGroups.get(sGroup).ID;
				GroupMember GM = new GroupMember(GroupId = groupID,
												 userOrGroupID = userToAdd);
				listAdd.add(GM);
			}
		}

		for(GroupMember GM: [Select ID
									  , GroupID
									  , Group.Name
									  , userOrGroupID
							 From GroupMember
							 Where Group.Name =: MapRemove.KeySet()]){

			if(mapRemove.containsKey(GM.Group.Name)){
				if(mapRemove.get(GM.Group.Name).Contains(GM.userOrGroupID)){
					listDel.add(GM);
				}
			}
		}

		if(listAdd != null && listAdd.size() > 0){
			System.savePoint sp = Database.setSavePoint();
		    try{
		        insert listAdd;
		    }catch(Exception e){
		        system.debug('Handling Exception:  '+e.getMessage() + ' ' + e.getStackTraceString());
		        Database.rollBack(sp);
		    }
		}
		if(listDel != null && listDel.size() > 0){
			System.savePoint sp = Database.setSavePoint();
		    try{
		        delete listDel;
		    }catch(Exception e){
		        system.debug('Handling Exception:  '+e.getMessage() + ' ' + e.getStackTraceString());
		        Database.rollBack(sp);
		    }
		}
	}
}