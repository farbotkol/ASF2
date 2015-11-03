public class ECO_HealthCheckEvaluator 
{

	public static List<Response> EvaluateProject(Id ProjectID)
	{
		List<Response> lResponses = new List<Response>();
		Map<Id,Project_Review_Trigger__c> mActiveTriggers = new Map<Id,Project_Review_Trigger__c>([select Id, Alert_Message__c, Comparator_1__c, Comparator_2__c, Evaluation_Frequency__c,
																									KPI_Metric__c, Name, Operator__c, KPI_Metric__r.Data_Type__c,  
																									KPI_Metric__r.Database_Field_Mapping_API_Name__c, KPI_Metric__r.Name, 
																									Comparator_1_KPI__c, TriggerDescription__c
																									from Project_Review_Trigger__c Where Is_Active__c = true and IsGlobal__c = true]);

		Map<String, KPI_Metric__c> mKPIMetrics = new Map<String, KPI_Metric__c>([select Id, Database_Field_Mapping_API_Name__c from KPI_Metric__c]);

		pse__Proj__c theProject = [select Id, Name, CarryingOutOrganization__r.Region__c from pse__Proj__c where Id = :ProjectID limit 1];

		Map<Id,Project_Review_Trigger__c> overrideRegionTriggersMap = new Map<Id,Project_Review_Trigger__c>();
		for(Project_Review_Trigger__c regionalTrigger:[select Alert_Message__c, Comparator_1__c, Comparator_2__c, Evaluation_Frequency__c, Id, KPI_Metric__c, Name, Operator__c, KPI_Metric__r.Data_Type__c, KPI_Metric__r.ThresholdDescription__c, 																								
															KPI_Metric__r.Database_Field_Mapping_API_Name__c, KPI_Metric__r.Name, Comparator_1_KPI__c, OverrideRegion__c, TriggerDescription__c, ParentProjectReviewTrigger__c
															from Project_Review_Trigger__c Where Is_Active__c = true and IsGlobal__c = false and OverrideRegion__c = :theProject.CarryingOutOrganization__r.Region__c
															Order By CreatedDate])
		{
			overrideRegionTriggersMap.put(regionalTrigger.ParentProjectReviewTrigger__c, regionalTrigger);
		}
																																		
		ECO_KPICalculation oKPICalc = new ECO_KPICalculation();
		ECO_KPICalculation.CalculationHolder calcHolder = oKPICalc.getProjectHealthCalculations(ProjectID);
		String sCalc = JSON.serialize(calcHolder);
		Map<String,Object> mapValues = (Map<String,Object>) JSON.deserializeUntyped(sCalc);

		for(Project_Review_Trigger__c prt : mActiveTriggers.values())
		{
			Object sValue;
			
			if(mapValues.containsKey(prt.KPI_Metric__r.Database_Field_Mapping_API_Name__c))
			{
				sValue = mapValues.get(prt.KPI_Metric__r.Database_Field_Mapping_API_Name__c);
			}
			
			system.debug('sValue:  '+sValue);
			if(sValue != null)
			{
				String dataType = prt.KPI_Metric__r.Data_Type__c;
				String operator = prt.Operator__c;
				String sComp1;
				String sComp2;
				Decimal dComp1;
				Decimal dComp2;
				Boolean bComp1;
				Date dtComp1;
				Date dtComp2;
				Decimal dValue;
				Boolean bValue;
				Date dtValue;
				Response r = new Response();
				r.triggerName = prt.Name;
				r.evalResult = false;
				r.regionOverride = false;
				r.thresholdDescription = prt.TriggerDescription__c;

				if(overrideRegionTriggersMap.containsKey(prt.Id))
				{
					sComp1 = overrideRegionTriggersMap.get(prt.Id).Comparator_1__c;
					sComp2 = overrideRegionTriggersMap.get(prt.Id).Comparator_2__c;
					r.regionOverride = true;
				}
				else
				{
					sComp1 = prt.Comparator_1__c;
					sComp2 = prt.Comparator_2__c;
				}
				
				//System.debug('sValue: ' + String.valueOf(sValue));
				//System.debug('sComp1: ' + String.valueOf(sComp1));
				//System.debug('sComp2: ' + String.valueOf(sComp2));

				if(prt.Comparator_1_KPI__c != null)
				{
					Decimal kpiMetricValue;
					kpiMetricValue = (Decimal)mapValues.get(mKPIMetrics.get(prt.Comparator_1_KPI__c).Database_Field_Mapping_API_Name__c);
					sComp1 = String.ValueOf(kpiMetricValue);
					dataType = 'Number';
				}
	
				if(dataType == 'Currency' || dataType == 'Percent' || dataType == 'Number')
				{
					dValue = Decimal.valueOf(String.valueOf(sValue));
					//dValue = (Decimal) sValue;
					dComp1 = Decimal.valueOf(sComp1);
					if(sComp2 != null)
					{
						dComp2 = Decimal.valueOf(sComp2);
					}
					if(operator == 'equal to')
					{
						if(dValue == dComp1)
						{
							r.evalResult = true;
							r.message = prt.Alert_Message__c.replace('[ACTUAL KPI VALUE]', String.valueOf(dValue));
						}
					}
					else if(operator == 'greater than')
					{
						if(dValue > dComp1)
						{
							r.evalResult = true;
							r.message = prt.Alert_Message__c.replace('[ACTUAL KPI VALUE]', String.valueOf(dValue));
						}
					}
					else if(operator == 'less than')
					{
						if(dValue < dComp1)
						{
							r.evalResult = true;
							r.message = prt.Alert_Message__c.replace('[ACTUAL KPI VALUE]', String.valueOf(dValue));
						}
					}
					else if(operator == 'greater than or equal to')
					{
						if(dValue >= dComp1)
						{
							r.evalResult = true;
							r.message = prt.Alert_Message__c.replace('[ACTUAL KPI VALUE]', String.valueOf(dValue));
						}
					}
					else if(operator == 'less than or equal to')
					{
						if(dValue <= dComp1)
						{
							r.evalResult = true;
							r.message = prt.Alert_Message__c.replace('[ACTUAL KPI VALUE]', String.valueOf(dValue));
						}
					}
					else if(operator == 'not equal to')
					{
						if(dValue != dComp1)
						{
							r.evalResult = true;
							r.message = prt.Alert_Message__c.replace('[ACTUAL KPI VALUE]', String.valueOf(dValue));
						}
					}
					else if(operator == 'between')
					{
						if((dValue <= dComp1 && dValue >= dComp2) || (dValue >= dComp1 && dValue <= dComp2))
						{
							r.evalResult = true;
							r.message = prt.Alert_Message__c.replace('[ACTUAL KPI VALUE]', String.valueOf(dValue));
						}
					}
					else if(operator == 'outside')
					{
						if((dValue < dComp1 || dValue > dComp2) || (dValue > dComp1 || dValue < dComp2))
						{
							r.evalResult = true;
							r.message = prt.Alert_Message__c.replace('[ACTUAL KPI VALUE]', String.valueOf(dValue));
						}
					}
				}
				else if(dataType == 'Date')
				{
					dtValue = Date.valueOf(sValue);
					dtComp1 = Date.valueOf(sComp1);
					if(sComp2 != null)
					{
						dtComp2 = Date.valueOf(sComp2);
					}
					if(operator == 'equal to')
					{
						if(dtValue == dtComp1)
						{
							r.evalResult = true;
							r.message = prt.Alert_Message__c.replace('[ACTUAL KPI VALUE]', String.valueOf(dtValue));
						}
					}
					else if(operator == 'greater than')
					{
						if(dtValue > dtComp1)
						{
							r.evalResult = true;
							r.message = prt.Alert_Message__c.replace('[ACTUAL KPI VALUE]', String.valueOf(dtValue));
						}
					}
					else if(operator == 'less than')
					{
						if(dtValue < dtComp1)
						{
							r.evalResult = true;
							r.message = prt.Alert_Message__c.replace('[ACTUAL KPI VALUE]', String.valueOf(dtValue));
						}
					}
					else if(operator == 'greater than or equal to')
					{
						if(dtValue >= dtComp1)
						{
							r.evalResult = true;
							r.message = prt.Alert_Message__c.replace('[ACTUAL KPI VALUE]', String.valueOf(dtValue));
						}
					}
					else if(operator == 'less than or equal to')
					{
						if(dtValue <= dtComp1)
						{
							r.evalResult = true;
							r.message = prt.Alert_Message__c.replace('[ACTUAL KPI VALUE]', String.valueOf(dtValue));
						}
					}
					else if(operator == 'not equal to')
					{
						if(dtValue != dtComp1)
						{
							r.evalResult = true;
							r.message = prt.Alert_Message__c.replace('[ACTUAL KPI VALUE]', String.valueOf(dtValue));
						}
					}
					else if(operator == 'between')
					{
						if((dtValue <= dtComp1 && dtValue >= dtComp2) || (dtValue >= dtComp1 && dtValue <= dtComp2))
						{
							r.evalResult = true;
							r.message = prt.Alert_Message__c.replace('[ACTUAL KPI VALUE]', String.valueOf(dtValue));
						}
					}
					else if(operator == 'outside')
					{
						if((dtValue < dtComp1 || dtValue > dtComp2) || (dtValue > dtComp1 || dtValue < dtComp2))
						{
							r.evalResult = true;
							r.message = prt.Alert_Message__c.replace('[ACTUAL KPI VALUE]', String.valueOf(dtValue));
						}
					}
				}
				else if(dataType == 'Boolean')
				{
					bValue = Boolean.valueOf(sValue);
					bComp1 = Boolean.valueOf(sComp1);
					if(operator == 'equal to')
					{
						if(bValue == bComp1)
						{
							r.evalResult = true;
							r.message = prt.Alert_Message__c.replace('[ACTUAL KPI VALUE]', String.valueOf(bValue));
						}
					}
					else if(operator == 'not equal to')
					{
						if(bValue != bComp1)
						{
							r.evalResult = true;
							r.message = prt.Alert_Message__c.replace('[ACTUAL KPI VALUE]', String.valueOf(bValue));
						}
					}
				}
				if(r.evalResult)
				{
					//lResponses.add(0,r);
					lResponses.add(r);
				}
				else
				{
					lResponses.add(r);
				}
			}
		}
		return lResponses;
	}

	public class Response
	{
		public String triggerName {get; set;}
		public String thresholdDescription {get; set;}
		public Boolean evalResult {get; set;}
		public String message {get; set;}
		public Boolean regionOverride {get; set;}
	}
}