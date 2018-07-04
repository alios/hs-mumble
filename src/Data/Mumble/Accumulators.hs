module Data.Mumble.Accumulators
  (accCount, accMean, accVariance, accMeanVariance
  ) where

import           Control.Lens.Fold





accCount :: Foldable f => f a -> Int
accCount = lengthOf folded

accCountMean :: (Foldable t, Fractional b) => t b -> (b, b)
accCountMean a =
  let c = fromRational . toRational . accCount $ a
  in (c, sum a / c)

accMean :: (Foldable t, Fractional b) => t b -> b
accMean = snd . accCountMean

accMeanVariance :: (Functor t, Foldable t, Fractional a) => t a -> (a, a)
accMeanVariance a =
  let (c, m) = accCountMean a
      x = (\b -> let s = b - m in s * s) <$> a
  in (m, (1 / c) * sum x)

accVariance :: (Functor t, Foldable t, Fractional a) => t a -> a
accVariance = snd . accMeanVariance
