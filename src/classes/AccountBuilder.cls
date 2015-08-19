public with sharing class AccountBuilder {
	
	String name = 'test account';
	Boolean isPartner = false;
	 
	public AccountBuilder withName(String name) {
        this.name = name;
        return this;
    }
    
    public AccountBuilder withPartner(Boolean isPartner) {
        this.isPartner = isPartner;
        return this;
    }
    
	 public Account build() {
        return new Account(name = this.name, isPartner = this.isPartner);
    }
}