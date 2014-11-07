# -*- coding: utf-8 -*-
#
# Copyright (c) 2013, 2014 Ghislain Antony Vaillant
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

from mv_plan cimport *

cdef class mv_plan_proxy:
    
    def __cinit__(self):
        self._plan = NULL
        self._is_initialized = False
        self._f_hat = None
        self._f = None
        self._plan_get_N_total = NULL
        self._plan_get_M_total = NULL
        self._plan_get_f_hat = NULL
        self._plan_set_f_hat = NULL
        self._plan_get_f = NULL
        self._plan_set_f = NULL
        self._plan_malloc = NULL
        self._plan_free = NULL
        self._plan_trafo = NULL
        self._plan_adjoint = NULL
        self._plan_finalize = NULL

    def __dealloc__(self):
        if self._is_initialized:
            self._plan_finalize(self._plan)
            self._plan_free(self._plan)
   
    cpdef trafo(self):
        if self._is_initialized:        
            with nogil:
                self._plan_trafo(self._plan)
        else:
            raise RuntimeError("plan is not initialized")
    
    cpdef adjoint(self):
        if self._is_initialized:        
            with nogil:
                self._plan_adjoint(self._plan)
        else:
            raise RuntimeError("plan is not initialized")

    @property
    def M_total(self):
        if self._is_initialized:
            return self._plan_get_M_total(self._plan)

    @property
    def N_total(self):
        if self._is_initialized:
            return self._plan_get_N_total(self._plan)


#from cnfft3 cimport nfft_plan, fftw_complex
#from cnfft3 cimport (nfft_malloc, nfft_init_1d, nfft_init_2d, nfft_init_3d,
#                     nfft_init, nfft_init_guru, nfft_trafo, nfft_adjoint,
#                     nfft_trafo_direct, nfft_adjoint_direct,
#                     nfft_precompute_one_psi, nfft_check, nfft_finalize)
#from cnfft3 cimport MALLOC_F_HAT, MALLOC_F, MALLOC_X
#from numpy cimport npy_intp, ndarray
#from numpy cimport PyArray_New
#from numpy cimport NPY_FLOAT64, NPY_COMPLEX128, NPY_CARRAY


#cdef class nfft_plan_proxy(mv_plan_complex_proxy):
#
#    cdef object _x
#
#    def __cinit__(self):
#        self._x = None
#
#    def __dealloc__(self):
#        if self.is_initialized:
#            nfft_finalize(self._get_plan_ptr())
#
#    @classmethod
#    def init_1d(cls, int N, int M):
#        cdef nfft_plan_proxy self = cls()
#        self._plan = <void *>nfft_malloc(sizeof(nfft_plan))
#        nfft_init_1d(self._get_plan_ptr(), N, M)
#        self._initialize_arrays()
#        return self
#
#    @classmethod
#    def init_2d(cls, int N1, int N2, int M):
#        cdef nfft_plan_proxy self = cls()
#        self._plan = <void *>nfft_malloc(sizeof(nfft_plan))
#        nfft_init_2d(self._get_plan_ptr(), N1, N2, M)
#        self._initialize_arrays()
#        return self
#
#    @classmethod
#    def init_3d(cls, int N1, int N2, int N3, int M):
#        cdef nfft_plan_proxy self = cls()
#        self._plan = <void *>nfft_malloc(sizeof(nfft_plan))
#        nfft_init_3d(self._get_plan_ptr(), N1, N2, N3, M)
#        self._initialize_arrays()
#        return self
#
#    @classmethod
#    def init(cls, int d, object N not None, int M):
#        cdef nfft_plan_proxy self = cls()
#        cdef int *N_ptr = NULL
#        if len(N) != d:
#            return None
#        N_ptr = <int*> nfft_malloc(d*sizeof(int))
#        for t in range(d):
#            N_ptr[t] = N[t]
#        self._plan = <void *>nfft_malloc(sizeof(nfft_plan))
#        nfft_init(self._get_plan_ptr(), d, N_ptr, M)
#        nfft_free(N_ptr)
#        self._initialize_arrays()
#        return self
#
#    @classmethod
#    def init_guru(cls, int d, object N not None, int M, object n not None,
#                  int m, int nfft_flags, int fftw_flags):
#        cdef nfft_plan_proxy self = cls()
#        cdef int *N_ptr = NULL
#        cdef int *n_ptr = NULL
#        cdef unsigned int nfft_flags_uint=0, fftw_flags_uint=0
#        if len(N) != d:
#            return None
#        if len(n) != d:
#            return None
#        N_ptr = <int*> nfft_malloc(d*sizeof(int))
#        n_ptr = <int*> nfft_malloc(d*sizeof(int))
#        for t in range(d):
#            N_ptr[t] = N[t]
#            n_ptr[t] = n[t]
#        # FIXME: do not force usage of internal malloc
#        nfft_flags = nfft_flags and MALLOC_F_HAT
#        nfft_flags = nfft_flags and MALLOC_F
#        nfft_flags = nfft_flags and MALLOC_X
#        self._plan = <void *>nfft_malloc(sizeof(nfft_plan))
#        nfft_init_guru(self._get_plan_ptr(), d, N_ptr, M, n_ptr, m,
#                       nfft_flags, fftw_flags)
#        nfft_free(N_ptr)
#        nfft_free(n_ptr)
#        self._initialize_arrays()
#        return self
#
#    cdef nfft_plan *_get_plan_ptr(self) nogil:
#        return <nfft_plan *> self._plan
#
#    cpdef trafo_direct(self):
#        if self.is_initialized:
#            with nogil:
#                nfft_trafo_direct(self._get_plan_ptr())
#        else:
#            raise RuntimeError("plan is not initialized")
#
#    cpdef adjoint_direct(self):
#        if self.is_initialized:
#            with nogil:
#                nfft_adjoint_direct(self._get_plan_ptr())
#        else:
#            raise RuntimeError("plan is not initialized")
#
#    cpdef precompute(self):
#        if self.is_initialized:
#            with nogil:
#                nfft_precompute_one_psi(self._get_plan_ptr())
#        else:
#            raise RuntimeError("plan is not initialized")
#
#    cpdef check(self):
#        cdef const char *c_errmsg
#        cdef bytes py_errmsg
#        if self.is_initialized:
#            c_errmsg = nfft_check(self.get_plan_ptr())
#            if c_errmsg != NULL:
#                py_errmsg = <bytes> c_errmsg
#                raise RuntimeError(py_errmsg)
#        else:
#            raise RuntimeError("plan is not initialized")
#
#    cdef void _initialize_arrays(self):
#        cdef nfft_plan *plan = NULL
#        cdef npy_intp shape[1]
#        cdef int flags
#        if not self.is_initialized:
#            return
#        plan = self._get_plan_ptr()
#        shape[0] = self.N_total
#        self._f_hat = PyArray_New(
#            ndarray, 1, shape, NPY_COMPLEX128, NULL,
#            <void *>plan.f_hat, sizeof(fftw_complex),
#            NPY_CARRAY, None)
#        shape[0] = self.M_total
#        self._f = PyArray_New(
#            ndarray, 1, shape, NPY_COMPLEX128, NULL,
#            <void *>plan.f, sizeof(fftw_complex),
#            NPY_CARRAY, None)
#        shape[0] = self.M_total * self.d
#        self._x = PyArray_New(
#            ndarray, 1, shape, NPY_FLOAT64, NULL,
#            <void *>plan.x, sizeof(double),
#            NPY_CARRAY, None)
#
#    property x:
#
#        def __get__(self):
#            return self._x
#
#        def __set__(self, object value):
#            if self._x is not None:
#                PyArray_CopyInto(self._x, value)
#            else:
#                raise RuntimeError("internal array is not initialized")
#
#    @property
#    def N_total(self):
#        if self.is_initialized:
#            return self._get_plan_ptr().N_total
#
#    @property
#    def M_total(self):
#        if self.is_initialized:
#            return self._get_plan_ptr().M_total
#
#    @property
#    def d(self):
#        if self.is_initialized:
#            return self._get_plan_ptr().d
#
#    @property
#    def N(self):
#        if self.is_initialized:
#            return [self._get_plan_ptr().N[i] for i in range(self.d)]
#
#    @property
#    def n(self):
#        if self.is_initialized:
#            return [self._get_plan_ptr().n[i] for i in range(self.d)]
#
#    @property
#    def m(self):
#        if self.is_initialized:
#            return self._get_plan_ptr().m
#
#    @property
#    def nfft_flags(self):
#         if self.is_initialized():
#            return self._get_plan_ptr().nfft_flags
#
#    @property
#    def fftw_flags(self):
#        if self.is_initialized():
#            return self._get_plan_ptr().fftw_flags