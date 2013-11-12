#= require jquery

$ ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))

  $('#payment-form').submit (event)->
    $form = $(this)
    $form.find("button").prop("disabled", true)
    Stripe.card.createToken($form, stripeResponseHandler)
    false

  stripeResponseHandler = (status, response)->
    $form = $("#payment-form")
    if response.error
      $form.find(".payment-errors").show().text(response.error.message)
      $form.find("button").prop("disabled", false)
    else
      token = response.id
      $form.append $("<input type=\"hidden\" name=\"stripe_token\" />").val(token)
      $form.get(0).submit()
