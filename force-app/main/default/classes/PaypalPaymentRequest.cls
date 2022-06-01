public class PaypalPaymentRequest
{    
  /**api request properties */
    public String intent;	
	public Payer payer;
	public List<Transactions> transactions;
	public String note_to_payer;	
	public Redirecturls redirect_urls;
	public class Payer {
		public String payment_method;
	}
	public class Transactions {
		public Amount amount;
		public String description;	
		public String custom;	
		public String invoice_number;	
		public Paymentoptions payment_options;
		public String soft_descriptor;	
		public ItemList item_list;
        public String notify_url;
	}
	public class Amount {
		public String total;
		public String currencyAmount;	
		public Details details;
	}
	public class Details {
		public String subtotal;
		public String tax;
		public String shipping;
		public String handling_fee;
		public String shipping_discount;
		public String insurance;
	}
	public class Paymentoptions  {
		public String allowed_payment_method;
	}
	public class ItemList {
		public List<Items> items;
		public Shippingaddress shipping_address;
	}
	public class Items {
		public String name;
		public String description;
		public String quantity;
		public String price;
		public String tax;
		public String sku;
		public String currencyItem;
	}
	public class Shippingaddress  {
		public String recipient_name;	
		public String line1;	
		public String line2;	
		public String city;	
		public String country_code;	
		public String postal_code;	
		public String phone;	
		public String state;	
	}
	public class Redirecturls  {
		public String return_url;
		public String cancel_url;
	}
}