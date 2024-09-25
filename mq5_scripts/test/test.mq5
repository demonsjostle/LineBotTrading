// Case for adding a new order (pending or market)
      case TRADE_TRANSACTION_ORDER_ADD:
      {
         ulong orderID = trans.order;
         ENUM_ORDER_TYPE orderType = trans.order_type;
         string symbol = trans.symbol;
         double profit = trans.price + _Point*TakeProfit;
         double stoploss = trans.price - _Point*StopLoss;

         // Check if the order is a BUY LIMIT
         if (orderType == ORDER_TYPE_BUY_LIMIT)
         {
            // Construct the message
            string mes = "=== Pending Order Placed === "
             +"\\nSymbol : "+trans_symbol
             +"\\nPosition : SELL LIMIT"
             +"\\nPending Price : "+DoubleToString(trans.price,_Digits)
             +"\\nTP : "+DoubleToString(profit,_Digits)
             +"\\nSL : "+DoubleToString(stoploss,_Digits)
             +"\\n\\nDate : "+TimeToString(TimeCurrent(),TIME_DATE)
             +"\\nTime : "+TimeToString(TimeCurrent(),TIME_MINUTES)
             +"\\nWin/Loss : None"
             +"\\n====================="
             +"\\nTrader : "+Username;
                         

            // Send the message to the API (LINE Messaging in your case)
            if (UseTelegram)
            {
               MessagingAPI(mes, activePackages);
            }
         } else if (orderType == ORDER_TYPE_SELL_LIMIT) {
            // Construct the message             
             string mes = "=== Pending Order Placed === "
             +"\\nSymbol : "+trans_symbol
             +"\\nPosition : SELL LIMIT"
             +"\\nPending Price : "+DoubleToString(trans.price,_Digits)
             +"\\nTP : "+DoubleToString(profit,_Digits)
             +"\\nSL : "+DoubleToString(stoploss,_Digits)
             +"\\n\\nDate : "+TimeToString(TimeCurrent(),TIME_DATE)
             +"\\nTime : "+TimeToString(TimeCurrent(),TIME_MINUTES)
             +"\\nWin/Loss : None"
             +"\\n====================="
             +"\\nTrader : "+Username;
                         
                         

            // Send the message to the API (LINE Messaging in your case)
            if (UseTelegram)
            {
               MessagingAPI(mes, activePackages);
            }
         }
      }
      break;
