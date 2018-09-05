# FindReferencesByString
Salesforce Lightning components and Apex class to show Lightning component, Apex class, Apex trigger, VisualForce, or Apex Component references by string.  

This is intended for a Dev Org or Sandbox, there is no test code.

There is no installer, so you can cut-n-paste the code into appropriately created placeholders in the Developer Console.  FindLightninBundleReferences uses the DataComponent for accessing the apex class.

Use Lightning App Builder to place the component on a lightning page.  In the Method field, include which AuraEnabled apex method to call to return results.  find targets Lightning Components, findPage targets VisualForce pages, findComponent targets apex components, findApex targets apex classes, and findTrigger targets apex triggers.  This is the only setting, unless you want to hack your own.

To use just type the string to search for in the field and click the Go button or Go Paste button.  Go Paste shows html code for pasting into an HTML based documentation file.  If you get results, you can click Find Depenendencies which will take the previous results and for each item, show any other Lightning Component that reference the item, show references to other Lightning Components in the item, show Apex class accessed by the component, and show Sboject references. Note it is looking at strings so there can be false positives returned.  The Find Dependencies is not implemented for Visualforce pages or Apex components, though would be easy to extend this to show if you need or which to hack it yourself.

There are absolutely no warranties for this code.  Use as you wish at your own risk.


