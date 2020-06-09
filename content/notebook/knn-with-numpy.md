---
title: 'Implementing KNN with numpy'
date: 2020-05-12
categories: ['numpy']
draft: true
---

This is an annotated version from the `numpy` partitioning section from Jake Van Der Plaas' Python Data Science Handbook. In the unlikely event that you haven't heard of it, I highly recommend checking it out (it's available for free as a set of Jupyter notebooks). You can find the exact section I'm recreating here: 

https://jakevdp.github.io/PythonDataScienceHandbook/02.08-sorting.html

I was reviewing the section to brush up on `numpy`'s broadcasting rules, and thought this example perfectly nailed how terse and elegant `numpy` code can be. I'm sure I'll revisit this example, I thought I'd clean up my notes and save them in a notebook. 

```python
import numpy as np
```

Generating 10 random 2-D coordinates:


```python
np.random.seed(0)
dat = np.random.randn(10, 2)
dat
```




    array([[ 1.76405235,  0.40015721],
           [ 0.97873798,  2.2408932 ],
           [ 1.86755799, -0.97727788],
           [ 0.95008842, -0.15135721],
           [-0.10321885,  0.4105985 ],
           [ 0.14404357,  1.45427351],
           [ 0.76103773,  0.12167502],
           [ 0.44386323,  0.33367433],
           [ 1.49407907, -0.20515826],
           [ 0.3130677 , -0.85409574]])



Here's the single line implementation of the KNN computation, before we break it down step-by-step:


```python
# single line implementation
dist_sq = np.sum((dat[:, np.newaxis, :] - dat[np.newaxis, :, :]) ** 2, axis=-1)
dist_sq
```




    array([[ 0.        ,  4.00502763,  1.90804084,  0.96670543,  3.48681075,
             3.7355896 ,  1.08359066,  1.74731927,  0.43929239,  3.67850689],
           [ 4.00502763,  0.        , 11.1466261 ,  5.72368281,  4.52060927,
             1.3154853 ,  4.53847911,  3.92357482,  6.2487442 , 10.02207345],
           [ 1.90804084, 11.1466261 ,  0.        ,  1.52389537,  5.81016221,
             8.8829441 ,  2.43208457,  3.74550245,  0.7356552 ,  2.4316139 ],
           [ 0.96670543,  5.72368281,  1.52389537,  0.        ,  1.42525042,
             3.22775829,  0.11028676,  0.49151953,  0.29882039,  0.89963684],
           [ 3.48681075,  4.52060927,  5.81016221,  1.42525042,  0.        ,
             1.15039622,  0.83041621,  0.30521614,  2.93051706,  1.77274602],
           [ 3.7355896 ,  1.3154853 ,  8.8829441 ,  3.22775829,  1.15039622,
             0.        ,  2.15650052,  1.34563435,  4.57630966,  5.35713773],
           [ 1.08359066,  4.53847911,  2.43208457,  0.11028676,  0.83041621,
             2.15650052,  0.        ,  0.14554337,  0.64416961,  1.15280571],
           [ 1.74731927,  3.92357482,  3.74550245,  0.49151953,  0.30521614,
             1.34563435,  0.14554337,  0.        ,  1.39329387,  1.4279052 ],
           [ 0.43929239,  6.2487442 ,  0.7356552 ,  0.29882039,  2.93051706,
             4.57630966,  0.64416961,  1.39329387,  0.        ,  1.81590771],
           [ 3.67850689, 10.02207345,  2.4316139 ,  0.89963684,  1.77274602,
             5.35713773,  1.15280571,  1.4279052 ,  1.81590771,  0.        ]])



Thanks to numpy's convenient reshaping functions and broadcasting behaviors, this single line computes the squared difference between each pair of points in a vectorized manner. 


```python
dat[:, 0] # first col, the x coordinates
```




    array([ 1.76405235,  0.97873798,  1.86755799,  0.95008842, -0.10321885,
            0.14404357,  0.76103773,  0.44386323,  1.49407907,  0.3130677 ])




```python
dat[:, 1] # second col, the y coordinates
```




    array([ 0.40015721,  2.2408932 , -0.97727788, -0.15135721,  0.4105985 ,
            1.45427351,  0.12167502,  0.33367433, -0.20515826, -0.85409574])



Here are the 10 points on a scatterplot: 


```python
import matplotlib.pyplot as plt
plt.scatter(dat[:, 0], dat[:, 1], s=100)
```




    <matplotlib.collections.PathCollection at 0x1133ebc90>




![png](/files/knn_with_numpy/output_10_1.png)


## Step 1: differences in each dimension

Compute differences in the x and y dimension for each pair of points. 

Note: you can review the full section on broadcasting [in this section](https://jakevdp.github.io/PythonDataScienceHandbook/02.05-computation-on-arrays-broadcasting.html). [This post](https://medium.com/@ian.dzindo01/what-is-numpy-newaxis-and-when-to-use-it-8cb61c7ed6ae) has a nice explanation as well. 

The first operand in the difference operation is the original 2-D `dat` array expanded over 10 rows. 


```python
dat[:, np.newaxis, :]
```




    array([[[ 1.76405235,  0.40015721]],
    
           [[ 0.97873798,  2.2408932 ]],
    
           [[ 1.86755799, -0.97727788]],
    
           [[ 0.95008842, -0.15135721]],
    
           [[-0.10321885,  0.4105985 ]],
    
           [[ 0.14404357,  1.45427351]],
    
           [[ 0.76103773,  0.12167502]],
    
           [[ 0.44386323,  0.33367433]],
    
           [[ 1.49407907, -0.20515826]],
    
           [[ 0.3130677 , -0.85409574]]])




```python
dat[:, np.newaxis, :].shape
```




    (10, 1, 2)



The second operand is the 2D `dat` array nested into a single 'row' (row ~ first axis). 


```python
dat[np.newaxis, :, :]
```




    array([[[ 1.76405235,  0.40015721],
            [ 0.97873798,  2.2408932 ],
            [ 1.86755799, -0.97727788],
            [ 0.95008842, -0.15135721],
            [-0.10321885,  0.4105985 ],
            [ 0.14404357,  1.45427351],
            [ 0.76103773,  0.12167502],
            [ 0.44386323,  0.33367433],
            [ 1.49407907, -0.20515826],
            [ 0.3130677 , -0.85409574]]])




```python
dat[np.newaxis, :, :].shape
```




    (1, 10, 2)



When the two are subtracted, the second operand is stretched from `(1, 10, 2)` to `(10, 10, 2)`, which triggers the first operand to be stretched from `(10, 1, 2)` to `(10, 10, 2)` (i.e. within each row, the point is repeated 10 times) 


```python
# for each pair of points, compute differences in their coordinates
# difference needs to be defined this way for broadcasting to work
# since first operand is spread out over rows, the full set of points can be subtracted from each pop

differences = dat[:, np.newaxis, :] -dat[np.newaxis, :, :]
differences.shape
```




    (10, 10, 2)



We can see the end result by inspecting one the elements of differences.

ex: for the first element, the first set of differences is `0, 0`, since that's the first point's distance from itself in teh x and y dimensions. 


```python
differences[0]
```




    array([[ 0.        ,  0.        ],
           [ 0.78531436, -1.84073599],
           [-0.10350564,  1.37743509],
           [ 0.81396393,  0.55151442],
           [ 1.8672712 , -0.01044129],
           [ 1.62000877, -1.0541163 ],
           [ 1.00301462,  0.27848219],
           [ 1.32018911,  0.06648288],
           [ 0.26997327,  0.60531547],
           [ 1.45098464,  1.25425295]])



Another sanity check: the diagonal is full of zeroes: 


```python
differences.diagonal()
```




    array([[0., 0., 0., 0., 0., 0., 0., 0., 0., 0.],
           [0., 0., 0., 0., 0., 0., 0., 0., 0., 0.]])



## Step 2: squared differences

Squaring the differences just requires a simple scalar broadcast: 


```python
# squaring each of the diffs
sq_diff = differences ** 2 
```

Inspecting the first element again: 


```python
sq_diff[0]
```




    array([[0.00000000e+00, 0.00000000e+00],
           [6.16718647e-01, 3.38830899e+00],
           [1.07134184e-02, 1.89732742e+00],
           [6.62537277e-01, 3.04168152e-01],
           [3.48670173e+00, 1.09020611e-04],
           [2.62442843e+00, 1.11116117e+00],
           [1.00603833e+00, 7.75523312e-02],
           [1.74289929e+00, 4.41997347e-03],
           [7.28855680e-02, 3.66406821e-01],
           [2.10535644e+00, 1.57315046e+00]])



## Step 3: summing squared differences

Now, we sum the coordinate differences along the last axis:


```python
dist_sq = sq_diff.sum(-1) # note that this is equivalent to squared_diff.sum(2)
```

We can inspect the diagonal once again to make sure each point has a squared distance of 0 from itself: 


```python
dist_sq
```




    array([[ 0.        ,  4.00502763,  1.90804084,  0.96670543,  3.48681075,
             3.7355896 ,  1.08359066,  1.74731927,  0.43929239,  3.67850689],
           [ 4.00502763,  0.        , 11.1466261 ,  5.72368281,  4.52060927,
             1.3154853 ,  4.53847911,  3.92357482,  6.2487442 , 10.02207345],
           [ 1.90804084, 11.1466261 ,  0.        ,  1.52389537,  5.81016221,
             8.8829441 ,  2.43208457,  3.74550245,  0.7356552 ,  2.4316139 ],
           [ 0.96670543,  5.72368281,  1.52389537,  0.        ,  1.42525042,
             3.22775829,  0.11028676,  0.49151953,  0.29882039,  0.89963684],
           [ 3.48681075,  4.52060927,  5.81016221,  1.42525042,  0.        ,
             1.15039622,  0.83041621,  0.30521614,  2.93051706,  1.77274602],
           [ 3.7355896 ,  1.3154853 ,  8.8829441 ,  3.22775829,  1.15039622,
             0.        ,  2.15650052,  1.34563435,  4.57630966,  5.35713773],
           [ 1.08359066,  4.53847911,  2.43208457,  0.11028676,  0.83041621,
             2.15650052,  0.        ,  0.14554337,  0.64416961,  1.15280571],
           [ 1.74731927,  3.92357482,  3.74550245,  0.49151953,  0.30521614,
             1.34563435,  0.14554337,  0.        ,  1.39329387,  1.4279052 ],
           [ 0.43929239,  6.2487442 ,  0.7356552 ,  0.29882039,  2.93051706,
             4.57630966,  0.64416961,  1.39329387,  0.        ,  1.81590771],
           [ 3.67850689, 10.02207345,  2.4316139 ,  0.89963684,  1.77274602,
             5.35713773,  1.15280571,  1.4279052 ,  1.81590771,  0.        ]])



## Step 4: sorting squared distances 

Sorting each row by distance:


```python
# again, notice: each point is closest to itself
nearest = np.argsort(dist_sq, axis = 1)
nearest
```




    array([[0, 8, 3, 6, 7, 2, 4, 9, 5, 1],
           [1, 5, 7, 0, 4, 6, 3, 8, 9, 2],
           [2, 8, 3, 0, 9, 6, 7, 4, 5, 1],
           [3, 6, 8, 7, 9, 0, 4, 2, 5, 1],
           [4, 7, 6, 5, 3, 9, 8, 0, 1, 2],
           [5, 4, 1, 7, 6, 3, 0, 8, 9, 2],
           [6, 3, 7, 8, 4, 0, 9, 5, 2, 1],
           [7, 6, 4, 3, 5, 8, 9, 0, 2, 1],
           [8, 3, 0, 6, 2, 7, 9, 4, 5, 1],
           [9, 3, 6, 7, 4, 8, 2, 0, 5, 1]])



## An improvement: using `np.argpartition` instead of `np.argsort`

We can improve the solution by using `np.argpartition`. Instead of sorting the full list of distances, it puts the K lowest values up front, and lists the remaining distances in an arbitrary order.  


```python
K = 2
nearest_partition = np.argpartition(dist_sq, K + 1, axis=1)
```

Connecting each point two its 2 nearest neighbors:


```python
plt.scatter(dat[:, 0], dat[:, 1], s=100)

# draw lines from each point to its two nearest neighbors
K = 2

for i in range(dat.shape[0]):
    for j in nearest_partition[i, :K+1]:
        plt.plot(*zip(dat[j], dat[i]), color='black')

```


![png](/files/knn_with_numpy/output_41_0.png)

