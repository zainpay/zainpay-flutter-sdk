abstract class TransactionCallBack {
  onTransactionSuccess(String id, String txRef, String url);
  onTransactionError();
  onCancelled();
}