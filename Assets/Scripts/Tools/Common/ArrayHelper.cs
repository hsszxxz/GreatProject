using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
public static class ArrayHelper
{
    public static T ArrayFind<T>(this T[] array,Func<T,bool> func)
    {
        foreach(T item in array)
        {
            if(func(item)) return item;
        }
        return default;
    }
    public static T[] FindAll<T>(this T[]array,Func<T,bool> func)
    {
        List<T> list = new List<T>();
        foreach (T item in array)
        {
            if (func(item))
            {
                list.Add(item);
            }
        }
        if (list.Count ==0)
        {
            return default;
        }
        T[] result = list.ToArray();
        return result;
    }
    public static T GetMin<T>(this T[]array ,Func<T,float> func)
    {
        T min = array[0];
        float minVal = func(min);
        foreach (T item in array)
        {
            if (func(item)<minVal)
            {
                min = item;
                minVal = func(item);
            }
        }
        return min;
    }
    public static Q[] Select<T,Q>(this T[]array, Func<T,Q> condition)
    {
        Q[] result = new Q[array.Length];
        for (int i = 0; i < result.Length; i++)
        {
            result[i] = condition(array[i]);
        }
        return result;
    }
}