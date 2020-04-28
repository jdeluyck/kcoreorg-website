---
id: 1905
title: Tweaking WooCommerce payment workflows
date: 2016-12-15T13:32:49+02:00
author: Jan
layout: single
guid: https://kcore.org/?p=1905
permalink: /2016/12/15/tweaking-woocommerce-payment-workflows/
categories:
  - WordPress
tags:
  - BACS
  - email output
  - overloading
  - payment gateway
  - woocommerce
  - WordPress
---
I'm playing part-time webmaster for the [choir](http://artemusicale.be/ensembles/kamerkoor-furiant/) I sing in, and as such, am getting up close and personal with [WooCommerce](https://woocommerce.com/). Quite a nifty shopping cart, but it does require a lot of tweaks to really make it work to your liking - unless you're willing to shell out a lot of cash.

The latest modification was changing the workflow of the payment gateways - more specifically, the [BACS gateway](https://docs.woocommerce.com/document/bacs/) (Bank Account Clearing System - or as we mortals call it, [wire transfer](https://en.wikipedia.org/wiki/Wire_transfer)).

The default flow for WooCommerce (for this gateway) is:

  1. Order is put in by customer
  2. Order is automatically flagged as _on-hold_, and a mail is sent out to the customer with the bank info
  3. Customer (supposedly) pays
  4. Store manager sees the payment, and flags order as _processing_ - another mail is sent out with the notification that it's being processed
  5. Store manager (hopefully) ships the product, flags the order as _completed _and another mail is sent out with 'order complete' status.

Now, for our uses, the _on-hold_ status is a bit superfluous (and we've had people getting confused by it).  
We'd rather have it go straight to _processing_, and have that mail contain the bank information (only for BACS payments, ofcourse).

After some testing, I came up with two solutions: One very hacky, and not maintainable, the other better. Both solutions need to be inserted in your theme's `functions.php` file.

```php
/* override gateway for BACS */
function my_core_gateways($methods) {
  foreach ($methods as &$method) {
    if($method == 'WC_Gateway_BACS') {
      $method = 'WC_Gateway_BACS_custom';
    }
  }
  return $methods;
}

/* custom gateway processor for BACS */
class WC_Gateway_BACS_custom extends WC_Gateway_BACS {
  public function email_instructions( $order, $sent_to_admin, $plain_text = false ) {

    if ( ! $sent_to_admin && 'bacs' === $order-&gt;payment_method && $order-&gt;has_status( 'processing' ) ) {
      if ( $this-&gt;instructions ) {
        echo wpautop( wptexturize( $this-&gt;instructions ) ) . PHP_EOL;
      }
 
     /* dirty hack to get access to bank_details */
     $reflector = new ReflectionObject($this);
     $method = $reflector-&gt;getMethod('bank_details');
     $method-&gt;setAccessible(true);
 
     $result = $method-&gt;invoke($this, $order-&gt;id);
    }
  }

  public function process_payment( $order_id ) {
    $order = wc_get_order( $order_id );

    // Mark as processing (we're awaiting the payment)
    $order-&gt;update_status( 'processing', __( 'Awaiting BACS payment', 'woocommerce' ) );

    // Reduce stock levels
    $order-&gt;reduce_order_stock();

    // Remove cart
    WC()-&gt;cart-&gt;empty_cart();

    // Return thankyou redirect
    return array(
      'result' =&gt; 'success',
      'redirect' =&gt; $this-&gt;get_return_url( $order )
    );
  }
}
```

I have several reservations with the code above: it's basically shamelessly copying and overloading the two functions of the parent class, and calling a private function which is internal to the parent class - both of which might cause trouble if there are big changes in WooCommerce. It works, but well, it's .. ugly. So, I looked for a better way to tackle this.

```php
add_action( 'woocommerce_email_before_order_table', 'add_order_email_instructions', 10, 2 );
add_action( 'woocommerce_thankyou', 'bacs_order_payment_processing_order_status', 10, 1 );

function bacs_order_payment_processing_order_status( $order_id ) {
  if ( ! $order_id ) {
    return;
  }

  $order = new WC_Order( $order_id );
 
  if ('bacs' === $order-&gt;payment_method && ('on-hold' == $order-&gt;status || 'pending' == $order-&gt;status)) {
    $order-&gt;update_status('processing');
  } else {
    return;
  }
}

function add_order_email_instructions( $order, $sent_to_admin ) {
  if ( ! $sent_to_admin && 'bacs' === $order-&gt;payment_method && $order-&gt;has_status( 'processing' ) ) {
    $gw = new WC_Gateway_BACS();
 
    $reflector = new ReflectionObject($gw);
    $method = $reflector-&gt;getMethod('bank_details');
    $method-&gt;setAccessible(true);
 
    $result = $method-&gt;invoke($gw, $order-&gt;id);
  }
}
```

Still not as clean as I'd like, as we're still invoking an internal function, but atleast we're using the proper hooks 
to tweak WooCommerce. I'll update if I ever find a better way to get to the bank details.