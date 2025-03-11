using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
/// <summary>
/// UIÊÂ¼þ¼àÌýÀà
/// </summary>
public delegate void PointerEventHandler(PointerEventData eventData);
public class UIEventListener : MonoBehaviour, IPointerDownHandler,IPointerClickHandler, IPointerUpHandler
{
    public event PointerEventHandler PointerDown;
    public event PointerEventHandler PointerUp;
    public event PointerEventHandler PointerClick;
    public void OnPointerClick(PointerEventData eventData)
    {
        if (PointerClick != null)PointerClick(eventData);
    }

    public void OnPointerDown(PointerEventData eventData)
    {
        if (PointerDown != null) PointerDown(eventData);
    }

    public void OnPointerUp(PointerEventData eventData)
    {
        if (PointerUp != null) PointerUp(eventData);
    }
}