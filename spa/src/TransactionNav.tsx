type Props = {
  onPrev?: () => void;
  onNext?: () => void;
};

export function TransactionNav({ onPrev, onNext }: Props) {
  return (
    <div className="flex items-center gap-3">
      <button className="btn" id="prev-link" onClick={onPrev} type="button">
        Prev
      </button>
      <button className="btn" id="next-link" onClick={onNext} type="button">
        Next
      </button>
    </div>
  );
}
